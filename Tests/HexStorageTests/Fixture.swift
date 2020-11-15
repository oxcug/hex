import Foundation
import HexStorage

extension Configuration {
    static var `default`: Configuration = {
        let config = try! Configuration(connections: [.memory])
        try! config.add(model: Example.self)
        return config
    }()
}

class Example: Model {
    
    override class func migrations() -> ModelMigrationBuilder {
        .build(
            .previous("example",
                      .attribute(.string, named: "soup")
            ),
            .latest("Example",
                    .attribute(.string, named: "string"),
                    .attribute(.date, named: "date"),
                    .attribute(.float, named: "double")
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
