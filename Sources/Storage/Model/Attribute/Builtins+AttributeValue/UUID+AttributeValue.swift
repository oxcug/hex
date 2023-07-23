//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation

extension UUID: AttributeValue {
    
    public static var type: AttributeValueType {
        .uuid
    }
    
    public var asSQL: String {
        "\"\(self.uuidString)\""
    }
    
    public init(sql: String) {
        self = UUID(uuidString: sql)!
    }
}
