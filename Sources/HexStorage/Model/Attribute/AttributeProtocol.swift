protocol AttributeProtocol {
    
    func metadata(using label: String, mirror: Mirror, descendent: Mirror.Child) -> AttributeMetadata?
        
    var defaultValue: AttributeValue? { get }
    
    var value: AttributeValue? { get }
}

public struct AttributeMetadata {
    
    public let name: String
    
    public let type: AttributeValueType
    
    public let nullable: Bool
}

public protocol AttributeValue: Codable {
    
    static var type: AttributeValueType { get }
    
    init(sql: String)
}

public enum AttributeValueType {
   case string, integer, float, date, uuid
}
