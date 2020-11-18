#if canImport(Foundation)
import Foundation
#elseif canImport(SwiftFoundation)
import SwiftFoundation
#else
#error("Cannot import dependency `Date` from either OpenFoundation or Foundation.")
#endif

extension Date: AttributeValue {

    public static var valueType: AttributeValueType {
        .date
    }
}
