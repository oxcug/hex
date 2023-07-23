//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#if canImport(Foundation) && (os(macOS) || os(iOS) || os(watchOS) || os(tvOS))

import Foundation

extension UserDefaults: KeyValueStorage {
    
    public func reset(scopeIdentifier: String?) {
        guard let scopeIdentifier else { UserDefaults.resetStandardUserDefaults() }
        removeSuite(named: scopeIdentifier)
    }
    
    public required init(scopeIdentifier: String?) {
        guard let scopeIdentifier else { self.init() }
        self.init(suiteName: scopeIdentifier)!
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
