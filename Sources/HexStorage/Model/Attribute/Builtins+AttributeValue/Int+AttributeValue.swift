extension Int: AttributeValue {
    
    public static var type: AttributeValueType {
        .integer
    }
    
    public init(sql: String) {
        self = Int(sql)!
    }
}
