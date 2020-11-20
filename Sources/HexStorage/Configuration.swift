import SQLite3

enum ConfigurationError: Error {
    case duplicateRegistrationForModel
    case unregisteredModel
}

private struct RelationalDatabase {
    
    var connection: OpaquePointer
    
    var latestTableMigrationCountMap: [String: UInt?]
    
    var pendingOperation: ModelOperation? = nil
}

/// Describes a method of connecting to a database provider (e.g SQLite, CloudKit, etc.)
public enum Connection {
    case memory, file(url: URL)
}

public class Configuration {
    
    private var dbs = [RelationalDatabase]()

    private func executeQuery(_ db: RelationalDatabase, sql: String) throws {
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        let rc = sqlite3_exec(db.connection, sql, { (_, argc, argv, columnName) -> Int32 in
            return 0
        }, nil, &errorMessage)
        
        guard rc == SQLITE_OK, errorMessage == nil else {
            fatalError("Failed to execute SQL Query. Error: \(String(cString: errorMessage!))")
        }
    }
    
    public func sync() throws {
        for db in dbs {
            guard let query = db.pendingOperation?.compile(for: self) else {
                continue
            }
            
            try executeQuery(db, sql: query)
        }
    }
    
    public func append(_ _operation: ModelOperation) {
        var op = _operation
        let name = String(describing: op.model.name)
        
        for i in 0..<dbs.count {
            /// Check if this model has been registered or not.
            /// - If not, then throw.
            guard let performedMigrationCount = dbs[i].latestTableMigrationCountMap[name] else {
                preconditionFailure("Failed to find migration count for model named \(name).")
            }
            
            /// Check if the migration builder has an pending migration operation,
            /// if so, wrap the appended operation in it. Otherwise, just set this as the db's pending op.
            let builder = ModelMigrationBuilder(numberOfPerformedMigrations: performedMigrationCount ?? nil, model: op.model)
            if let migration = op.model.migrate(using: builder) {
                op.dependencies.append(migration)
            }
            
            if var pendingOp =  dbs[i].pendingOperation {
                pendingOp.dependencies.append(op)
            } else {
                dbs[i].pendingOperation = op
            }
        }
    }
    
    public func register(model: RawModel.Type...) throws {
        try register(models: model)
    }
    
    public func register(models: [RawModel.Type]) throws {
        /// Convert list of models into a map (verifying that there are no duplicate names).
        for model in models {
            let name = String(describing: model.name)
            
            /// Initially set the value of the migrationCount map for each db to a wrapped nil value unless it's already been retrieved from the db when the configuration was initialized.
            /// This way, we don't worry about updating the
            for i in 0..<dbs.count {
                if !dbs[i].latestTableMigrationCountMap.contains(where: { $0.key == name }) {
                    dbs[i].latestTableMigrationCountMap[name] = Optional<UInt>.init(nilLiteral: ())
                }
            }
        }
    }
    
    /// Prepares a `StorageConfiguration` object to be used with the Storage Operation APIs.
    /// - Parameter connections: An array of defined methods for connecting to one or more compatible storage types.
    public required init(connections: [Connection]) throws {
        /// Initialize a new SQL Database connection for each one described by the caller.
        /// See `connections` parameter.
        dbs = connections.map {
            let rc: Int32
            var db: OpaquePointer?
            
            /// Passing nil to `sqlite3_open_v2` uses the default (OS Specific) VFS (virtual file system).
            /// **NOTE:** passing `[]` and `""` are  invalid VFS specifiers.
            switch $0 {
            case .memory:
                rc = sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil)
            case .file(let url):
                rc = sqlite3_open_v2(url.path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil)
            }
            
            guard rc == SQLITE_OK, let handle = db else {
                fatalError("Failed to open database. Error (code: \(rc)): \(String(cString: sqlite3_errstr(rc))).")
            }
            
            return RelationalDatabase(connection: handle, latestTableMigrationCountMap: [:])
        }
        
        /// Last but not least, we prepare our new database connections by running the query below.
        ///
        /// By running this query we establish the folllowing:
        /// 1. It validates we have a completely functional `rw+`connection to the database.
        /// 2. It creates the required `__migrations` table .
        /// 3. returns the latest "head" migration index for each model so we
        ///   know what migrations are missing before we begin operating on the database.
        ///
        /// By validating those items (at the cost of some overhead) we further the goals of this library by gaining
        /// significant ease of use benefits between the `Model` class and the `migrations` pattern.
        try dbs.forEach {
            let query = """
                CREATE TABLE IF NOT EXISTS `__migrations` (
                  `modelName` VARCHAR(64) NOT NULL,
                  `numberOfMigrationsPerformed` INTEGER NOT NULL default '0'
                );

                SELECT `modelName`, `numberOfMigrationsPerformed` FROM `__migrations`;
                """
            try executeQuery($0, sql: query)
        }
    }
    
    /// Cleanup the database state by closing all open connections.
    deinit {
        /// Now that we've prepared the database for the given models, we can now close out all our connections until they're needed again.
        dbs.forEach {
            sqlite3_close($0.connection)
        }
    }
}
