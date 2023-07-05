//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation

public class Transaction<Schema: SchemaRepresentable> {
    
    weak var config: Configuration?
    
    init(config: Configuration) {
        self.config = config
    }
        
    @discardableResult
    public func sync() throws -> [Model<Schema>] {
        var aggregate: [Model<Schema>]
        guard let config = config else {
            preconditionFailure("Configuration doesn't exist within this context anymore!")
        }
        
        for i in 0..<config.dbs.count {
            guard let query = config.dbs[i].pendingOperation?.compile(for: config) else {
                continue
            }
            config.dbs[i].pendingOperation = nil
            
            var db = config.dbs[i]
            var out = [[String: AttributeValue?]]()
            
            try config.executeQuery(&db, sql: query) { result in
                var row = [String: AttributeValue?]()
                result.forEach { (k, v) in
                    guard let column = Schema.attributeMetadata(for: k) else { return }
                    let value: AttributeValue?
                    
                    if v.lowercased() != "null" {
                        switch column.type {
                        case .date: value = ISO8601DateFormatter().string(from: Date(sql: v))
                        case .float: value = Double(sql: v)
                        case .integer: value = Int(sql: v)
                        case .string: value = v
                        case .uuid: value = UUID(sql: v)
                        }
                    } else {
                        value = nil
                    }
                    
                    row[k] = value
                }
                out.append(row)
            }
            
            guard out.count > 0 else { continue }

            aggregate = out.map {
                Model<Schema>(from: $0)
            }
            return aggregate
        }
        
        return []
    }
}
