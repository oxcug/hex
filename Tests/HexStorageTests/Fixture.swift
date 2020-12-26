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
    
    override class func migrate<T>(using current: ModelMigrationBuilder<T>) -> ModelOperation<T>? where T : RawModel {
        try! current
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
    
    @Attribute(defaultValue: "<default>") var string: String
    
    @Attribute(defaultValue: .distantFuture) var date: Date
    
    @Attribute(defaultValue: 99) var double: Double
    
    @NullableAttribute var nullableString: String?
    
    @NullableAttribute var nullableDate: Date?
    
    @NullableAttribute var nullableDouble: Double?
}
