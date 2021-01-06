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
        return lhs.string == rhs.string &&
                lhs.date == rhs.date &&
                lhs.double == rhs.double &&
                lhs.integer == rhs.integer &&
                lhs.nullableString == rhs.nullableString &&
                lhs.nullableDate == rhs.nullableDate &&
                lhs.nullableDouble == rhs.nullableDouble &&
                lhs.nullableInteger == rhs.nullableInteger
    }
    
    override class func migrate<T>(using current: ModelMigrationBuilder<T>) -> ModelOperation<T>? where T : RawModel {
        try! current.versioned(
                .latest("example",
                    .attribute(.string, named: "string"),
                    .attribute(.date, named: "date"),
                    .attribute(.float, named: "double"),
                    .attribute(.integer, named: "integer"),
                    .attribute(.string, named: "nullableString"),
                    .attribute(.date, named: "nullableDate"),
                    .attribute(.float, named: "nullableDouble"),
                    .attribute(.integer, named: "nullableInteger")
            )
        )
    }
    
    @Attribute(defaultValue: "<Default Value>") var string: String
    
    @Attribute(defaultValue: .distantFuture) var date: Date
    
    @Attribute(defaultValue: 99) var double: Double

    @Attribute(defaultValue: 1) var integer: Int
    
    @NullableAttribute var nullableString: String?
    
    @NullableAttribute var nullableDate: Date?
    
    @NullableAttribute var nullableDouble: Double?

    @NullableAttribute var nullableInteger: Int?
}
