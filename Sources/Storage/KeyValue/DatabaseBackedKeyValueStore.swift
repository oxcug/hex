//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/22/23.
//

import Foundation

public struct DatabaseBackedKeyValueStore: KeyValueStorage {
    public static func storage(for scopeIdentifier: String?) -> KeyValueStorage {
        DatabaseBackedKeyValueStore.init()
    }
    
    public func reset(scopeIdentifier: String?) {
        
    }
    
    public func getObject(forKey: String) -> Any? {
        nil
    }
    
    public func set(object: Any?, forKey: String) {
        
    }
    
    public init() {
        
    }
}
