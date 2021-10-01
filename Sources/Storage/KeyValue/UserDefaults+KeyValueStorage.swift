//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#if canImport(Foundation)
import Foundation

extension UserDefaults: KeyValueStorage {
    
    public func getObject(forKey: String) -> Any? {
        guard let obj = object(forKey: forKey) else { return nil }
        return obj
    }
    
    public func set(object: Any?, forKey: String) {
        setValue(object, forKey: forKey)
    }
}

#endif
