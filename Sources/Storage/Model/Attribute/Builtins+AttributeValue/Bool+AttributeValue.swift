///
/// Copyright © 2021-2023 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

extension Bool: AttributeValue {
    
    public static var type: AttributeValueType { .bool }
    
    public var asSQL: String {
        self ? "TRUE" : "FALSE"
    }
    
    public init(sql: String) {
        self = sql == "TRUE" ? true : false
    }
}
