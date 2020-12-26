#if canImport(Foundation)
import Foundation

public typealias Date = Foundation.Date
#elseif canImport(SwiftFoundation)
import SwiftFoundation

public typealias Date = SwiftFoundation.Date
#else
#error("Cannot import dependency `Date` from either OpenFoundation or Foundation.")
#endif
