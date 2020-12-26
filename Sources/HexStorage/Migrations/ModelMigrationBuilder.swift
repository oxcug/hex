/// A data structure that contains information about the current state of a model, and, using a helper method
/// like `versioned` creates the Operations necessary to migrate a model to it's latest schema.
public struct ModelMigrationBuilder<Model: RawModel> {
    
    /// The number of migrations that have been performed for this model in the past (recorded by the `__migrations` table internally).
    var numberOfPerformedMigrations: UInt?
    
    /// Constructs a `ModelMigrationBuilder` using the model schema definitions provided in the migrations parameter.
    /// Using the provided list of schema's, it automatically builds the necessary operations to migrate an older version of the model to the newest.
    ///
    /// - Parameter schemas: A list of schema's that define each historical version of the model.
    /// - Returns: A new `ModelMigration`.
    public func versioned(_ schemas: ModelSchema...) throws -> ModelOperation<Model>? {
        ///
        /// Validate the `schemas` parameter:
        ///     - If multiple latest migrations found, throw `.multipleLatestModelMigrations`
        ///     - if no latest migration found, throw `.noLatestModelMigration`
        let latestSchemas = schemas.filter { $0.isLatest }
        guard let latestSchema = latestSchemas.first, latestSchemas.count == 1 else {
            throw latestSchemas.count > 1 ? MigrationError.multipleLatestModelMigrations
                                          : MigrationError.noLatestModelMigration
        }
        
        ///
        /// Validate the number of perfomed migrations:
        ///     - If there is no count (e.g `numberOfPerformedMigrations` is nil), then we have not created the table yet.
        ///     - if the number of performed migrations is greater than the number provided then `throw` (the user is not providing all the schemas).
        ///     - Otherwise generate the operations for each inbetween schema version defined in the provided by the caller.
        guard let numberOfPerformedMigrations = numberOfPerformedMigrations else {
            return ModelOperation.createTable(validating: latestSchema)
        }
        
        guard numberOfPerformedMigrations <= schemas.count else {
            throw MigrationError.mismatchingVersionsCount
        }
        
        return nil
    }
}
