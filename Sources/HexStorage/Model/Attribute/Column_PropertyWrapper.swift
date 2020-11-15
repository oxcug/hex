import Foundation

/// A Convenience Wrapper to export a variable and link it to a value represented in a Table.
@propertyWrapper public struct Attribute<T: AttributeValue>: AttributeProtocol {
            
    public var cachedValue: T?

    public var wrappedValue: T {
        get { cachedValue! }
        set {  }
    }
    
    public init(cachedValue: T? = nil) {
        self.cachedValue = cachedValue
    }
    
    func metadata(with attributeName: String) -> AttributeMetadata {
        return .init(name: attributeName, valueType: T.valueType, nullable: false)
    }
 }
