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
    
<<<<<<< HEAD
    func metadata(with mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata? {
        // TODO: #ifdef out for !DEBUG.
        /// @see caller `Model.columns(filterByName:) ` for more info.
        guard let label = descendent.label else { return nil }
        return AttributeMetadata(name: label, type: T.type, nullable: false)
=======
    func metadata<M: RawModel>(with mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata<M>? {
        // TODO: #ifdef out for !DEBUG.
        /// @see caller `Model.columns(filterByName:) ` for more info.
        guard let label = descendent.label else { return nil }
        return AttributeMetadata(name: label, type: T.type, nullable: false, keyPath: \M.[checkedMirrorDescendant: label] as PartialKeyPath<M>)
>>>>>>> b478d27cfbdffa9632629d511abfe028bbd6d7c1
    }
}
