/// Convenience Property Wrapper API for defining a nullable Model Attribute.
@propertyWrapper public struct NullableAttribute<T: AttributeValue>: AttributeProtocol {
    
    public var cachedValue: T?
        
    var defaultValue: AttributeValue?
    
    var value: AttributeValue? {
        cachedValue
    }

    public var wrappedValue: Optional<T> {
        get { cachedValue }
        set {  }
    }
        
    public init(defaultValue: T? = nil) {
        self.defaultValue = defaultValue
        self.cachedValue = defaultValue
    }
    
    func metadata(with attributeName: String) -> AttributeMetadata {
        return .init(name: attributeName, type: T.type, nullable: true)
    }
}
