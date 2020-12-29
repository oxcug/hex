protocol AttributeProtocol {
    
    func metadata(with mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata?
        
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
