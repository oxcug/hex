/// Convenience Property Wrapper API for defining a nullable Model Attribute.
@propertyWrapper public struct NullableAttribute<T: AttributeValue>: AttributeProtocol {
    
    public var cachedValue: T?
        
    var defaultValue: AttributeValue?
    
    var value: AttributeValue? {
        cachedValue
    }

    public var wrappedValue: Optional<T> {
        get { cachedValue }
        set { cachedValue = newValue }
    }
        
    public init(defaultValue: T? = nil) {
        self.defaultValue = defaultValue
        self.cachedValue = defaultValue
    }
    
    func metadata(using label: String, mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata? {
        // TODO: #ifdef out for !DEBUG.
        /// @see caller `Model.columns(filterByName:) ` for more info.
        return AttributeMetadata(name: label, type: T.type, nullable: true)
    }
}
