#if canImport(Foundation)
import Foundation

public typealias URL = Foundation.URL
#elseif canImport(SwiftFoundation)
import SwiftFoundation

public typealias URL = SwiftFoundation.URL
#else
#error("Cannot import dependency `URL` from either OpenFoundation or Foundation.")
#endif
