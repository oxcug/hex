//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#if canImport(Foundation) && (os(macOS) || os(iOS) || os(watchOS) || os(tvOS))

import Foundation

class UserDefaultsBackedKeyValueStorage: KeyValueStorageProtocol {
    
    required init(config: Configuration, scope: (any KeyValueStorageScope)?) {
        
    }
    
    func getObject<T>(forKey: String) -> T? where T : AttributeValue {
        nil
    }
    
    func set<T>(object: T?, forKey: String) where T : AttributeValue {
        
    }
    
    func reset(scope: (any KeyValueStorageScope)?) {
        
    }
}

//extension UserDefaults: KeyValueStorageProtocol {
//
//    public func reset(scopeIdentifier: String?) {
//        guard let scopeIdentifier else {
//            UserDefaults.resetStandardUserDefaults()
//            return
//        }
//        removePersistentDomain(forName: scopeIdentifier)
//    }
//
//    public static func storage(for scopeIdentifier: String?) -> KeyValueStorage {
//        guard let scopeIdentifier else { return Self.standard }
//        return UserDefaults(suiteName: scopeIdentifier)!
//    }
//
//    public func getObject(forKey: String) -> Any? {
//        guard let obj = object(forKey: forKey) else { return nil }
//        return obj
//    }
//
//    public func set(object: Any?, forKey: String) {
//        setValue(object, forKey: forKey)
//    }
//}

#endif
