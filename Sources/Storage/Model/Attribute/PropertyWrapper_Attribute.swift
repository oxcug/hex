///
/// Copyright © 2021-2023 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/benefic-org/benefic/blob/eng/LICENSE

/// A Convenience Wrapper to export a variable and link it to a value represented in a Table.
@propertyWrapper public struct Attribute<T: AttributeValue>: AttributeProtocol {
        
    private var _transformer: AttributeTransformer?
    
    private var _defaultValue: T?
    
    public var defaultValue: AttributeValue? { _defaultValue }
    
    private var _value: T? = nil
    
    public var value: AttributeValue? { _value ?? defaultValue }
    
    public var transformer: AttributeTransformer? { _transformer }
    
    public var wrappedValue: T {
        get { _value ?? _defaultValue! }
        set { _value = newValue }
    }
    
    public init(wrappedValue: T) {
        self.init(wrappedValue)
    }
    
    public init(_ defaultValue: T? = nil, transform transformer: (get:(Any?) -> T, set: ((T) -> Any?))? = nil) {
        self._defaultValue = defaultValue
        if let transformer {
            self._transformer = .init(get: transformer.get, set: { transformer.set($0 as! T) })
        }
        self._value = nil
    }

    public init(_ defaultValue: T, transform transformer: (get:(Any?) -> T, set: ((T) -> Any?))? = nil) {
        self._defaultValue = defaultValue
        if let transformer {
            self._transformer = .init(get: transformer.get, set: { transformer.set($0 as! T) })
        }

        self._value = nil
    }
    
    public func metadata(using label: String, mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata? {
        // TODO: #ifdef out for !DEBUG.
        /// @see caller `Model.columns(filterByName:) ` for more info.
        return AttributeMetadata(name: label, type: T.type, nullable: false, transformer: self.transformer)
    }
}

extension Optional: AttributeValue where Wrapped : AttributeValue {
    public static var type: AttributeValueType {
        Wrapped.type
    }
    
    public var asSQL: String {
        self?.asSQL ?? "NULL"
    }
    
    public init(sql: String) {
        self = Wrapped.init(sql: sql)
    }
}
