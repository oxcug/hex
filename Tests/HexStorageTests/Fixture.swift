import HexStorage

extension Configuration {
    static var `default`: Configuration = {
        let config = try! Configuration(connections: [.memory])
        try! config.register(model: Example.self)
        return config
    }()
}

class Example: Model {
    
    override class var name: StaticString {
        "example"
    }
    
    override class func migrate(using builder: ModelMigrationBuilder) -> ModelOperation? {
        try! builder
            .versioned(
                .latest("example",
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
