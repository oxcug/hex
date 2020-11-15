import Foundation

public struct Operation<T: RawModel> {
    
    public enum QueryMethod {
        case all, first, last
    }
    
    internal enum Style {
        case upsert, find, delete
    }
    
    internal enum Subject {
        case column, table
    }
    
    var columnValues = [String: AttributeValue]()

    var style: Style? = nil

    var dependencies: [Operation]
    
    func compile(for configuration: Configuration) -> String {
        var out: String
        switch style {
        case .upsert:
            out = """
                INSERT IN \(T.tableName(for: configuration));
                """
        case .find: fallthrough // TODO: Implement other operation styles.
        case .delete: fallthrough
        case .none: out = ""
        }
        
        for d in dependencies {
            out = out + d.compile(for: configuration)
        }
        
        return out
    }
    
    public func find(_ method: QueryMethod) -> Operation {
        return Operation(dependencies: [])
    }
    
    /// Instructs the configuratino to update or insert this model.
    public func upsert() -> Operation {
        return Operation(dependencies: [self])
    }
    
    /// Deletes this model from the .
    public func delete() -> Operation {
        return Operation(dependencies: [])
    }
}
