//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

extension String: AttributeValue {
    
    public static var type: AttributeValueType {
        .string
    }
    
    public var asSQL: String {
        "\"\(self)\""
    }

    public init(sql: String) {
        self = sql
    }
}
