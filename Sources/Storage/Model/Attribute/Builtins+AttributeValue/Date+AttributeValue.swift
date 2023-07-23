//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation

extension Date: AttributeValue {
    
    public var isNullable: Bool { true }
    
    public static var type: AttributeValueType {
        .date
    }
    
    public var asSQL: String {
        "\"2023-07-01 10:22:00\""
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-DD hh:mm:ss Z"
//        return "\"\(formatter.string(from: self))\""
    }
    
    public init(sql: String) {
        self = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-DD hh:mm:ss Z"
//        self = formatter.date(from: sql)!
    }
}

//extension Optional<Date>: NullableAttributeValue {}
