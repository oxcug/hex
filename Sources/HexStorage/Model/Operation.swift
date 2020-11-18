internal enum OperationType {
    case create, read, update, delete
}

public struct Operation {
    
    internal enum Subject {
        case column, table, row
    }
    
    var models: [RawModel.Type]? = nil
    
    var type: OperationType? = nil
    
    var name: String? = nil
    
    var subject: Subject? = nil

    var dependencies: [Operation]? = nil
    
    init() {
        
    }
    
    init(_ type: OperationType, _ subject: Subject, named: String) {
        self.type = type
        self.subject = subject
    }
    
    func compile<Model: RawModel>(model: Model, for configuration: Configuration) -> String {
        var out: String
        
        switch type {
        case .create:
            out = """
                INSERT IN \(Model.tableName(for: configuration));
                """
        case .update: fallthrough
        case .read: fallthrough // TODO: Implement other operation styles.
        case .delete: fallthrough
        case .none: out = ""
        }
        
        for d in dependencies ?? [] {
            out = out + d.compile(model: model, for: configuration)
        }
        
        return out
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
