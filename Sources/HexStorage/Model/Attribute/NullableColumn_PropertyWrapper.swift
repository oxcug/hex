import Foundation

@propertyWrapper public struct NullableAttribute<T: AttributeValue>: AttributeProtocol {
    
    private typealias T = T
    
    public var cachedValue: T? = nil

    public var wrappedValue: Optional<T> {
        get { cachedValue }
        set {  }
    }
    
    public init() {
    }
    
    public init(cachedValue: T? = nil) {
        self.cachedValue = cachedValue
    }
    
    func metadata(with columnName: String) -> AttributeMetadata {
        return .init(name: columnName, valueType: T.valueType, nullable: true)
    }
}
