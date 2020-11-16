import Foundation

/// Convenience Property Wrapper API for defining a nullable Model Attribute.
@propertyWrapper public struct NullableAttribute<T: AttributeValue>: AttributeProtocol {
    
    public var cachedValue: T?

    public var wrappedValue: Optional<T> {
        get { cachedValue }
        set {  }
    }
        
    public init(cachedValue: T? = nil) {
        self.cachedValue = cachedValue
    }
    
    func metadata(with attributeName: String) -> AttributeMetadata {
        return .init(name: attributeName, valueType: T.valueType, nullable: true)
    }
}
