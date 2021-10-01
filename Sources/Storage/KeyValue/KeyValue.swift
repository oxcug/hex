//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

/// A key value convenience property wrapper that exposes
@propertyWrapper public struct KeyValue<T> where T : Codable {
    
    let config: Configuration
    
    let `default`: T
    
    let key: String
    
    public var wrappedValue: T {
        get {
            guard let val = config.kv.getObject(forKey: key) as? T else { return `default` }
            return val
        }
        set {
            config.kv.set(object: newValue, forKey: key)
        }
    }

    public init(_ config: Configuration, key: StaticString, default: T) {
        self.config = config
        self.`default` = `default`
        self.key = String(describing: key)
    }
}

@propertyWrapper public struct NullableKeyValue<T> where T : Codable {
    
    let config: Configuration
    
    let `default`: T?

    let key: String

    public var wrappedValue: T? {
        get {
            guard let val = config.kv.getObject(forKey: key) as? T else { return nil }
            return val
        }
        set {
            config.kv.set(object: newValue, forKey: key)
        }
    }
    
    public init(_ config: Configuration, key: StaticString, default: T? = nil) {
        self.config = config
        self.`default` = `default`
        self.key = String(describing: key)
    }
}
