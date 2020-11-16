import Foundation

public struct ModelMigration {
    
    /// Constructs a `ModelMigrationBuilder` using the model schema definitions provided in the migrations parameter.
    /// Using the provided list of schema's, it automatically builds the necessary operations to migrate an older version of the model to the newest.
    /// - Parameter migrations: A list of schema's that define each historical version of the model.
    /// - Returns: A new migration builder.
    public func versioned(_ migrations: ModelSchema...) throws -> Operation {
        /// Find the latest model migration,
        ///     If multiple found, throw `.multipleLatestModelMigrations`
        ///     If none found, throw `.noLatestModelMigration`
        let latestMigrations = migrations.filter { $0.isLatest }
        guard let latestMigration = latestMigrations.first, latestMigrations.count == 1 else {
            throw latestMigrations.count > 1 ? MigrationError.multipleLatestModelMigrations
                                             : MigrationError.noLatestModelMigration
        }
        
        return Operation()
    }
}
