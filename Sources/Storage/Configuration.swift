//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import SQLite3

#if os(WASI)
import SwiftFoundation
#else
import Foundation
#endif

enum SQLError: Error {
    case executionFailure(String)
}

enum ConfigurationError: Error {
    case duplicateRegistrationForModel
    case unregisteredModel
}

struct RelationalDatabase {
    
    var connection: OpaquePointer
    
    var latestTableMigrationCountMap: [String: UInt?]
    
    var pendingOperation: AnyModelOperation? = nil
}

public protocol KeyValueStorage {
    func getObject(forKey: String) -> Any?
    
    func set(object: Any?, forKey: String)
}

/// Describes a method of connecting to a database provider (e.g SQLite, CloudKit, etc.)
public enum Connection {
    case memory, file(url: URL)
}

public class Configuration {
    
    var kv: KeyValueStorage
    
    var dbs: [RelationalDatabase]
    
    typealias ExecuteQueryBlock = ([String:String]) -> Void

    func executeQuery(_ db: inout RelationalDatabase, sql: String, block: @escaping ExecuteQueryBlock) throws {
        var errorMessage: UnsafeMutablePointer<Int8>? = nil
        var blockCopy = block
        
        try withUnsafeMutablePointer(to: &blockCopy) {
            let rc = sqlite3_exec(db.connection, sql, { (pointer, argc, argv, columnName) -> Int32 in
                guard let result = pointer?.assumingMemoryBound(to: ExecuteQueryBlock.self).pointee else {
                    fatalError("Param is not of type `ExecuteQueryBlock`!")
                }
                
                var results = [String:String]()
                for i in 0..<Int(argc) {
                    guard let cBuffer = argv?[Int(i)], let cName = columnName?[i] else {
                        return SQLITE_ABORT
                    }
                    
                    let column = String(cString: cName)
                    let value = String(cString: cBuffer)
                    results[column] = value
                }
                
                result(results)
                return 0
            }, $0, &errorMessage)
            
            guard rc == SQLITE_OK, errorMessage == nil else {
                throw SQLError.executionFailure("Failed to execute SQL Query. Error: \(String(cString: errorMessage!))")
            }
        }
        
        db.pendingOperation = nil
    }

    public func register(schema: any SchemaRepresentable.Type...) throws {
        try register(schemas: schema)
    }
    
    public func register(schemas: [any SchemaRepresentable.Type]) throws {
        /// Convert list of models into a map (verifying that there are no duplicate names).
        for schema in schemas {
            let name = String(describing: schema._schemaName.description)
            
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
    public required init(keyValueStore kvStore: KeyValueStorage, connections: [Connection]) throws {
        kv = kvStore
        
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
        for i in 0..<dbs.count {
            let query = """
                CREATE TABLE IF NOT EXISTS `__migrations` (
                  `modelName` VARCHAR(64) NOT NULL,
                  `numberOfMigrationsPerformed` INTEGER NOT NULL default '0'
                );

                SELECT `modelName`, `numberOfMigrationsPerformed` FROM `__migrations`;
                """
            var latestTableMigrationCountMap = [String: UInt?]()
            try executeQuery(&dbs[i], sql: query)  { result in
                guard let modelName = result["modelName"],
                      let numberOfMigrationsPerformed = result["numberOfMigrationsPerformed"],
                      let version = UInt(numberOfMigrationsPerformed)
                else {
                    fatalError()
                }
                latestTableMigrationCountMap[modelName] = version
            }
            dbs[i].latestTableMigrationCountMap = latestTableMigrationCountMap
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

#if canImport(Foundation)

extension Configuration {
    
    /// Convenience init for Configuration that will initialize it with a KeyValue store that uses  Apple's`Foundation` framework's `UserDefaults` but still requires the `DatabaseConnection` parameter.
    /// - Parameter connections: A list of database connections.
    /// - Throws: When the database connection is invalid or cannot be utilized.
    public convenience init(connections: [Connection]) throws {
        try self.init(keyValueStore: UserDefaults.standard, connections: connections)
    }
}

#endif
