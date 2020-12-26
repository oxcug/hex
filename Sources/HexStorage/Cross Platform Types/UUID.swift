#if canImport(Foundation)
import Foundation

public typealias UUID = Foundation.UUID
#elseif canImport(SwiftFoundation)
import SwiftFoundation

public typealias UUID = SwiftFoundation.UUID
#else
#error("Cannot import dependency `UUID` from either OpenFoundation or Foundation.")
#endif
