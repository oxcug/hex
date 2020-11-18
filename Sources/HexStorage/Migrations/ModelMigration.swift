/// A data structure that contains information about the current state of a model, and, using a helper method
/// like `versioned` creates the Operations necessary to migrate a model to it's latest schema.
public struct ModelMigration {
    
    /// Sets the number of migrations that have been performed for this model in the past.
    var numberOfPerformedMigrations: UInt? = nil
    
    var target: Model.Type
    
    /// Constructs a `ModelMigrationBuilder` using the model schema definitions provided in the migrations parameter.
    /// Using the provided list of schema's, it automatically builds the necessary operations to migrate an older version of the model to the newest.
    /// - Parameter schemas: A list of schema's that define each historical version of the model.
    /// - Returns: A new migration builder.
    public func versioned(_ schemas: ModelSchema...) throws -> Operation {
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
        /// Validate the number of recorded migrations:
        ///     - If it is, we need to generate the operations for each inbetween schema defined in the provided list of versions.
        ///     - Else, build a Operation that will create the table with the right schema from scratch.
        guard let numberOfPerformedMigrations = numberOfPerformedMigrations, numberOfPerformedMigrations > 0 else {
            return Operation(.create, .table, named: "")
        }
                
        return Operation()
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - schema: <#schema description#>
    ///   - to: <#to description#>
    /// - Returns: <#description#>
    func generateOperation(from schema: ModelSchema, to: ModelSchema) -> Operation? {
        guard schema == to else { return nil }
        
        return nil
    }
}
