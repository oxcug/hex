import Foundation
import SQLite3

private struct RelationalDatabase {
    var sql: OpaquePointer
    var migrationHeads: [String: UInt]
}

/// Describes a method of connecting to a database provider (e.g SQLite, CloudKit, etc.)
public enum Connection {
    case memory, file(url: URL)
}


public class Configuration {
    
    public var tableNamePrefix: String?
    
    public var columnNamePrefix: String?
    
    private var dbs = [RelationalDatabase]()
    
//    func apply(_ operation: Operation) {
//
//    }
    
    private func executeQuery(_ db: RelationalDatabase, sql: String) throws {
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        let rc = sqlite3_exec(db.sql, sql, { (_, argc, argv, columnName) -> Int32 in
            return 0
        }, nil, &errorMessage)
        
        guard rc == SQLITE_OK, errorMessage == nil else {
            fatalError("Failed to execute SQL Query. Error: \(String(cString: errorMessage!))")
        }
    }
    
    public func add(model: RawModel.Type...) throws {
        try add(models: model)
    }
    
    public func add(models: [RawModel.Type]) throws {
        /// Convert list of models into a map (verifying that there are no duplicate names).
        var modelMap = [String:RawModel.Type]()
        for model in models {
            guard modelMap[model.tableName(for: self)] == nil else {
                fatalError("Found duplicate table for model: \(model).")
            }
            
            modelMap[model.tableName(for: self)] = model
            
            for db in dbs {
                try executeQuery(db, sql: """
                    """)
            }
        }
    }
    
    /// Prepares a `StorageConfiguration` object to be used with the Storage Operation APIs.
    /// - Parameter tableNamePrefix: A string to prefix all tables for all connections with. Defaults to the applications bundle identifier.
    /// - Parameter connections: An array of defined methods for connecting to one or more compatible storage types.
    public required init(
        tableNamePrefix: String? = ("\(Bundle.main.bundleIdentifier ?? "<unknown_bundle>")."),
        columnNamePrefix: String? = nil,
        connections: [Connection]) throws
    {
        self.tableNamePrefix = tableNamePrefix
        self.columnNamePrefix = columnNamePrefix
        
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
            
            return RelationalDatabase(sql: handle, migrationHeads: .init())
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
                  `lastMigratedIndex` INTEGER NOT NULL default '0'
                );

                SELECT `modelName`, `lastMigratedIndex` FROM `__migrations`;
                """
            try executeQuery($0, sql: query)
        }
    }
    
    /// Cleanup the database state by closing all open connections.
    deinit {
        /// Now that we've prepared the database for the given models, we can now close out all our connections until they're needed again.
        dbs.forEach {
            sqlite3_close($0.sql)
        }
    }
}
