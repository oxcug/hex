extension String: AttributeValue {

    public static var type: AttributeValueType {
        .string
    }
    
    public init(sql: String) {
        self = sql
    }
}
