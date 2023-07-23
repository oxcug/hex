//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#if canImport(Foundation) && (os(macOS) || os(iOS) || os(watchOS) || os(tvOS))

import Foundation

extension UserDefaults: KeyValueStorage {
    
    public func reset(scopeIdentifier: String?) {
        guard let scopeIdentifier else {
            UserDefaults.resetStandardUserDefaults()
            return
        }
        removeSuite(named: scopeIdentifier)
    }
    
    public static func storage(for scopeIdentifier: String?) -> KeyValueStorage {
        guard let scopeIdentifier else { return Self.standard }
        return UserDefaults(suiteName: scopeIdentifier)!
    }
    
    public func getObject(forKey: String) -> Any? {
        guard let obj = object(forKey: forKey) else { return nil }
        return obj
    }
    
    public func set(object: Any?, forKey: String) {
        setValue(object, forKey: forKey)
    }
}

#endif
