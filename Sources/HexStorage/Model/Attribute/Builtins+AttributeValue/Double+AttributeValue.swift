extension Double: AttributeValue {

    public static var type: AttributeValueType {
        .float
    }
    
    public init(sql: String) {
        self = Double(sql)!
    }
}
