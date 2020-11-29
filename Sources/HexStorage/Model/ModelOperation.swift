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

extension AttributeProtocol {
    var sql: String {
        guard let sqlValue = value ?? defaultValue else {
            return "NULL"
        }
        
        return String(describing: sqlValue)
    }
}

public protocol AnyModelOperation {
    
}

public struct ModelOperation<Model: RawModel> {
    
    var type: OperationType? = nil
    
    var subject: OperationSubject? = nil
    
    var values: [String:AttributeProtocol?]? = nil

    var dependencies: [Self]
    
    init() {
        self.dependencies = []
    }
    
    init(_ type: OperationType,
         _ subject: OperationSubject,
         values: [String: AttributeProtocol?]? = nil,
         dependencies: [Self]? = nil)
    {
        self.type = type
        self.subject = subject
        self.values = values
        self.dependencies = dependencies ?? []
    }
    
    static func createTable<T>(validating schema: ModelSchema) -> Self<T> {
        return Self(.create, .table)
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
                out = "CREATE TABLE `\(Model.name)` ("
                
                let cols = Model.columns()
                for i in 0..<cols.count {
                    let col = cols[i]
                    out += "\t`\(col.name)` \(col.type.sql)"
                    
                    if !col.nullable {
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
                guard let compactValues = values?.compactMapValues({ $0 }) else {
                    fatalError("Performing create but didn't provide values.")
                }
                
                let keys = compactValues.keys
                
                out += """
                    INSERT INTO `\(model.name)` (\(keys.map { "`\($0)`" }.joined(separator: ", ")))
                    VALUES (\(keys.map { "'\(compactValues[$0]!.sql)'" }.joined(separator: ", ")));\n
                    """
            }
        case .read:
            switch subject {
            case .row:
                guard let compactValues = values?.compactMapValues({ $0 }) else {
                    fatalError("Performing create but didn't provide values.")
                }
                
                out += """
                    SELECT *
                    FROM `\(model.name)`
                    WHERE \(compactValues.map { "`\($0.key)` = '\($0.value.sql)'"  });\n
                    """
            case .table:
                out += """
                    SELECT * FROM `\(model.name)`;\n
                    """

            }
        // TODO: Implement other operation styles.
        case .update: fallthrough
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
