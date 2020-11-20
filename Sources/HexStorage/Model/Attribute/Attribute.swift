protocol AttributeProtocol {
    
    func metadata(with columnName: String) -> AttributeMetadata
}

public struct AttributeMetadata {
    
    public let name: String
    
    public let valueType: AttributeValueType
    
    public let nullable: Bool
}

public protocol AttributeValue {
    
    static var valueType: AttributeValueType { get }
}

public enum AttributeValueType {
   case string, integer, float, date
}
