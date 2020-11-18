#if canImport(Foundation)
import Foundation
#elseif canImport(SwiftFoundation)
import SwiftFoundation
#else
#error("Cannot import dependency `Date` from either OpenFoundation or Foundation.")
#endif

import HexStorage

extension Configuration {
    static var `default`: Configuration = {
        let config = try! Configuration(connections: [.memory])
        try! config.add(model: Example.self)
        return config
    }()
}

class Example: Model {
    
    override class func migrate(from current: ModelMigration) -> HexStorage.Operation {
        try! current.versioned(
            .latest("Example",
                    .attribute(.string, named: "string"),
                    .attribute(.date, named: "date"),
                    .attribute(.float, named: "double"),
                    .attribute(.string, named: "nullableString"),
                    .attribute(.date, named: "nullableDate"),
                    .attribute(.float, named: "nullableDouble")
            )
        )
    }
    
    @Attribute var string: String
    
    @Attribute var date: Date
    
    @Attribute var double: Double
    
    @NullableAttribute var nullableString: String?
    
    @NullableAttribute var nullableDate: Date?
    
    @NullableAttribute var nullableDouble: Double?
}
