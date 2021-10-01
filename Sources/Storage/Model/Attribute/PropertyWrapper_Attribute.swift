//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

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

    func metadata(using label: String, mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata? {
        // TODO: #ifdef out for !DEBUG.
        /// @see caller `Model.columns(filterByName:) ` for more info.
        return AttributeMetadata(name: label, type: T.type, nullable: false)
    }
}
