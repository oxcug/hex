import Foundation
import HexStorage

extension Configuration {
    static var `default`: Configuration = {
        let config = try! Configuration(connections: [.memory])
        try! config.register(model: ExampleModel.self)
        return config
    }()
}

class ExampleModel: Model, Equatable {

    override class var name: StaticString {
        "example"
    }

    static func ==(lhs: ExampleModel, rhs: ExampleModel) -> Bool {
        return lhs.string == rhs.string
    }
    
    override class func migrate<T>(using current: ModelMigrationBuilder<T>) -> ModelOperation<T>? where T : RawModel {
        try! current.versioned(
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
    
    @Attribute(defaultValue: "<Default Value>") var string: String
    
    @Attribute(defaultValue: .distantFuture) var date: Date
    
    @Attribute(defaultValue: 99) var double: Double
    
    @NullableAttribute var nullableString: String?
    
    @NullableAttribute var nullableDate: Date?
    
    @NullableAttribute var nullableDouble: Double?
}
