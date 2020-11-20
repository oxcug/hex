import SQLite3

public extension RawModel {
        
    /// Instructs the configuration to update or insert this model.
    func upsert() -> ModelOperation {
        return ModelOperation(model: Self.self, .create, .row, values: [:])
    }
    
    /// Deletes this model from the .
    func delete() -> ModelOperation {
        return ModelOperation(model: Self.self, .delete, .row)
    }
    

}
