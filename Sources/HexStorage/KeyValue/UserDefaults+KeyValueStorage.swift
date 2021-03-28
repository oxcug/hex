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
