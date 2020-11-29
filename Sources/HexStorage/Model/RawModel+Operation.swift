import SQLite3

public extension RawModel {
        
    /// Creates a operation to `upsert` (update or insert) this model.
    func upsert() -> ModelOperation<Self> {
        var values = [String:AttributeProtocol]()
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard let label = child.label else {
                continue
            }
            
            /// Remove underscore from label if it's present.
            let name: String
            if label.hasPrefix("_") {
                name = String(label.dropFirst())
            } else {
                name = label
            }
            
            guard let value = child.value as? AttributeProtocol, let col = Self.column(named: name) else {
                continue
            }
            
            values[col.name] = value
        }
        
        return ModelOperation(model: Self.self, .create, .row, values: values)
    }
    
    static func findAll() -> ModelOperation<Self> {
        ModelOperation(model: Self.self, .read, .table)
    }
    
    /// Deletes this model from the .
    func delete() -> ModelOperation<Self> {
        return ModelOperation(model: Self.self, .delete, .row)
    }
}
