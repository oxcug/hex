//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

public struct AttributeTransformer {
    var get: ((Any?) -> Any?)
    var set: ((Any) -> Any?)
}

public protocol AttributeProtocol {
    
    func metadata(using label: String, mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata?
        
    var defaultValue: AttributeValue? { get }
    
    var value: AttributeValue? { get }
}

public struct AttributeMetadata {
    
    public let name: String
    
    public let type: AttributeValueType
    
    public let nullable: Bool
    
    public var transformer: AttributeTransformer?
	
	public let traits: [AttributeTraits]
    
	public init(name: String, type: AttributeValueType, nullable: Bool, traits: [AttributeTraits] = [], transformer: AttributeTransformer? = nil) {
        self.name = name
        self.type = type
        self.nullable = nullable
        self.transformer = transformer
		self.traits = traits
    }
}

public protocol AttributeValue {
        
    static var type: AttributeValueType { get }
    
    var asSQL: String { get }
    
    init(sql: String)
}

public protocol NullableAttributeValue: AttributeValue {}

extension AttributeValue {
    
    static var isNullable: Bool {
        return self as? NullableAttributeValue == nil
    }
}

public enum AttributeValueType {
   case string, integer, float, date, uuid, bool
}
