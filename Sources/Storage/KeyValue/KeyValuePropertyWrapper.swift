//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

/// A key value convenience property wrapper that exposes
@propertyWrapper public struct KeyValue<U> where U : AttributeValue {
    
    let config: Configuration
    
    let `default`: U
    
    let key: String
    
    public var wrappedValue: U {
        get {
            guard let val: U = config.kv.getObject(forKey: key) else { return `default` }
            return val
        }
        set {
            config.kv.set(object: newValue, forKey: key)
        }
    }

    public init(_ config: Configuration, key: StaticString, default: U) {
        self.config = config
        self.`default` = `default`
        self.key = String(describing: key)
    }
}
