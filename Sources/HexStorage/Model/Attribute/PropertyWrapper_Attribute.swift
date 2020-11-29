/// A Convenience Wrapper to export a variable and link it to a value represented in a Table.
@propertyWrapper public struct Attribute<T: AttributeValue>: AttributeProtocol {
    
    var _defaultValue: T
    
    var defaultValue: AttributeValue? { _defaultValue }
    
    var _value: T? = nil
    
    var value: AttributeValue? { _value }

    public var wrappedValue: T {
        get { _value ?? _defaultValue }
        set { _value = newValue }
    }
    
    public init(defaultValue: T) {
        self._defaultValue = defaultValue
        self._value = nil
    }

    func metadata(with attributeName: String) -> AttributeMetadata {
        return AttributeMetadata(name: attributeName, type: T.type, nullable: false)
    }
 }
