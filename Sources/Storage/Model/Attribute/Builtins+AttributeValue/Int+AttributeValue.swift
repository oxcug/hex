//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

extension Int: AttributeValue {
    
    public static var type: AttributeValueType {
        .integer
    }
    
    public var asSQL: String {
        "'\(self)'"
    }

    public init(sql: String) {
        self = Int(sql)!
    }
}
 
//extension Optional<Int>: NullableAttributeValue {}
