//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

public struct AttributeSchema {
    
    var name: String
    
    var valueType: AttributeValueType
    
    public static func attribute(_  valueType: AttributeValueType, named: StaticString, previousName: StaticString? = nil) -> Self {
        return Self(name: String(describing: named), valueType: valueType)
    }
}

extension AttributeSchema: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return  lhs.name == rhs.name && lhs.valueType == rhs.valueType
    }
}
