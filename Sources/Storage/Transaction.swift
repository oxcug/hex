//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

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
            var out = [String:Any?]()
            
            try config.executeQuery(&db, sql: query) { result in
                result.forEach { (k, v) in
                    guard let column = Model.column(named: k) else { return }
                    let value: Any?
                    
                    if v.lowercased() != "null" {
                        switch column.type {
                        case .date: value = ISO8601DateFormatter().string(from: Date(sql: v)) 
                        case .float: value = Double(sql: v)
                        case .integer: value = Int(sql: v)
                        case .string: value = v
                        case .uuid: value = UUID(sql: v).uuidString
                        }
                    } else {
                        value = nil
                    }
                    
                    out[k] = value
                }
            }
            
            guard out.count > 0 else { continue }

            do {
                let decoder = JSONDecoder()
                let raw = try JSONSerialization.data(withJSONObject: out)

                guard let modelString = String(data: raw, encoding: .utf8),
                    let modelData = modelString.data(using: .utf8) else {
                    preconditionFailure("Failed to convert \(out) to JSON object.")
                }

                let model = try decoder.decode(Model.self, from: modelData)
                aggregate.append(model)
            } catch {
                print("Failed to encode dictionary as JSON object! \(error)")
            }
        }
        
        return aggregate
    }
}
