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
