protocol AttributeProtocol {
    
    func metadata(with columnName: String) -> AttributeMetadata
        
    var defaultValue: AttributeValue? { get }
    
    var value: AttributeValue? { get }
}

public struct AttributeMetadata {
    
    public let name: String
    
    public let type: AttributeValueType
    
    public let nullable: Bool
}

public protocol AttributeValue {
    
    static var type: AttributeValueType { get }
    
    init(sql: String)
}

public enum AttributeValueType {
   case string, integer, float, date
}
