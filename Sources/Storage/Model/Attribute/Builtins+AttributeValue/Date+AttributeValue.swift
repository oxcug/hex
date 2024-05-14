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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:ss"
        return "\"\(formatter.string(from: self))\""
    }
    
    public init(sql: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:ss"
        self = formatter.date(from: sql)!
    }
}

//extension Optional<Date>: NullableAttributeValue {}
