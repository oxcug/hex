//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

extension Double: AttributeValue {
    
    public var isNullable: Bool { false }

    public static var type: AttributeValueType {
        .float
    }
    
    public var asSQL: String {
        "\(self)"
    }
    
    public init(sql: String) {
        self = Double(sql)!
    }
}
