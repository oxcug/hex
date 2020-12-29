import Foundation

public class Transaction<Model: RawModel> {
    
    weak var config: Configuration?
    
    init(config: Configuration) {
        self.config = config
    }
        
    @discardableResult
    public func sync() throws -> [Model] {
        var aggregate = [Model]()
        guard let config = config else {
            preconditionFailure("Configuration doesn't exist within this context anymore!")
        }
        
        for i in 0..<config.dbs.count {
            guard let query = config.dbs[i].pendingOperation?.compile(for: config) else {
                continue
            }
            config.dbs[i].pendingOperation = nil
            
            var db = config.dbs[i]
            var out = [String:Codable?]()
            
            try config.executeQuery(&db, sql: query) { result in
                result.forEach { (k, v) in
                    guard let column = Model.column(named: k) else { return }
                    let value: AttributeValue?
                    
                    if v.lowercased() != "null" {
                        switch column.type {
                        case .date: value = Date(sql: v)
                        case .float: value = Double(sql: v)
                        case .integer: value = Int(sql: v)
                        case .string: value = v
                        case .uuid: value = UUID(sql: v)
                        }
                    } else {
                        value = nil
                    }
                    
                    out[k] = value
                }
            }
            
//            aggregate.append(obj)
        }
        
        return aggregate
    }
}
