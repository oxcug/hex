enum OperationType {
    case create, read, update, delete
}

enum OperationSubject {
    case table, row
}

enum OperationParameter {
    case value
}

extension AttributeValueType {
    var sql: String {
        switch self {
        case .date: return "DATETIME"
        case .float: return "REAL"
        case .integer: return "INTEGER"
        case .string: return "TEXT"
        }
    }
}

public struct ModelOperation {
    
    var model: RawModel.Type
    
    var type: OperationType? = nil
    
    var subject: OperationSubject? = nil
    
    var values: [String:AttributeValue]? = nil

    var dependencies = [Self]()
    
    init(model: RawModel.Type) {
        self.model = model
    }
    
    init(model: RawModel.Type,
         _ type: OperationType,
         _ subject: OperationSubject,
         values: [String: AttributeValue]? = nil,
         dependencies: [Self]? = nil)
    {
        self.model = model
        self.type = type
        self.subject = subject
        self.values = values
        self.dependencies = dependencies
    }
    
    static func createTable(using model: RawModel.Type, validating schema: ModelSchema) -> Self {
        return Self(model: model, .create, .table)
    }
    
    func compile(for configuration: Configuration) -> String {
        var out: String = ""
        
        for dependency in dependencies {
            out = out + dependency.compile(for: configuration)
        }
        
        guard let type = type, let subject = subject else {
            return out
        }
        
        switch type {
        case .create:
            switch subject {
            case .table:
                out = "CREATE TABLE `\(model.name)`("
                
                let cols = model.columns(for: configuration)
                for i in 0..<cols.count {
                    let col = cols[i]
                    out += "\t`\(col.name)` \(col.valueType.sql)"
                    
                    if col.nullable {
                        out += " NOT NULL"
                    }
                    
                    /// Add comma to every line except the last one (trailing commas are invalid SQL)
                    if i < cols.count - 1 {
                        out += ","
                    }
                    
                    out += "\n"
                }
                
                out += ");\n"
            case .row:
                out = "INSERT () VALUES ()"
            }
        case .update: fallthrough
        case .read: fallthrough // TODO: Implement other operation styles.
        case .delete: out = ""
        }
        
        return out
    }

    /// Adds this operation to the configuration's operation buffer to be executed at the next `push`.
    /// - Parameter configuration: The target configuration to perform this operation on.
    @discardableResult public func commit(using configuration: Configuration) -> Configuration {
        configuration.append(self)
        return configuration
    }
}
