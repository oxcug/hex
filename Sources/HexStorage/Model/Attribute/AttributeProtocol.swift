protocol AttributeProtocol {
    
<<<<<<< HEAD:Sources/HexStorage/Model/Attribute/AttributeProtocol.swift
    func metadata(with mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata?
=======
    func metadata<M: RawModel>(with mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata<M>?
>>>>>>> b478d27cfbdffa9632629d511abfe028bbd6d7c1:Sources/HexStorage/Model/Attribute/AttributeProtocol.swift
        
    var defaultValue: AttributeValue? { get }
    
    var value: AttributeValue? { get }
}

public struct AttributeMetadata<M: RawModel> {
    
    public let name: String
    
    public let type: AttributeValueType
    
    public let nullable: Bool
    
    public let keyPath: PartialKeyPath<M>
}

public protocol AttributeValue: Codable {
    
    static var type: AttributeValueType { get }
    
    init(sql: String)
}

public enum AttributeValueType {
   case string, integer, float, date, uuid
}
