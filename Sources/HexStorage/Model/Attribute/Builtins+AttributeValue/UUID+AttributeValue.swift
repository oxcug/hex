<<<<<<< HEAD
#if os(WASI)
import SwiftFoundation
#else
import Foundation
#endif

=======
>>>>>>> b478d27cfbdffa9632629d511abfe028bbd6d7c1
extension UUID: AttributeValue {
    
    public static var type: AttributeValueType {
        .uuid
    }
    
    public init(sql: String) {
        self = UUID(uuidString: sql)!
    }
}
