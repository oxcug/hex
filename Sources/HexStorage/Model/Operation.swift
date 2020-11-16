import Foundation

public struct Operation {
    
    public enum QueryMethod {
        case all, first, last
    }
    
    internal enum Style {
        case upsert, find, delete, rename
    }
    
    internal enum Subject {
        case column, table
    }
    
    var columnValues = [String: AttributeValue]()

    var style: Style? = nil
    
    var name: String? = nil
    
    var subject: Subject? = nil

    var dependencies = [Operation]()
    
    init() {
        
    }
    
    init(_ style: Style, _ subject: Subject) {
        self.style = style
        self.subject = subject
    }
    
    func compile<Model: RawModel>(model: Model, for configuration: Configuration) -> String {
        var out: String
        
        switch style {
        case .upsert:
            out = """
                INSERT IN \(Model.tableName(for: configuration));
                """
        case .rename: fallthrough
        case .find: fallthrough // TODO: Implement other operation styles.
        case .delete: fallthrough
        case .none: out = ""
        }
        
        for d in dependencies {
            out = out + d.compile(model: model, for: configuration)
        }
        
        return out
    }
    
    public func find(_ method: QueryMethod) -> Operation {
        return Operation()
    }
    
    /// Instructs the configuratino to update or insert this model.
    public func upsert() -> Operation {
        return Operation()
    }
    
    /// Deletes this model from the .
    public func delete() -> Operation {
        return Operation()
    }
}

extension Operation {
    
    public func commit(using configuration: Configuration) {
        
    }
}
