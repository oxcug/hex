//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

#if os(WASI)
import SwiftFoundation
#else
import Foundation
#endif

extension UUID: AttributeValue {
    
    public static var type: AttributeValueType {
        .uuid
    }
    
    public init(sql: String) {
        self = UUID(uuidString: sql)!
    }
}
