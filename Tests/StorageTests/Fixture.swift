//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation
import Storage

extension Configuration {
    static var `default`: Configuration = {
        let config = try! Configuration(keyValueStore: UserDefaults(suiteName: "Tests")!, connections: [.memory])
        try! config.register(schema: ExampleSchema.self)
        return config
    }()
}

#if swift(>=5.9)
@Schema
final class ExampleSchema {
    typealias Conformant = ExampleSchemaProtocol
    var string: String = "<Default Value>"
    var date: Date = Date()
    var double: Double = 99
    var integer: Int = 1
    var nullableString: String?
    var nullableDate: Date?
    var nullableDouble: Double?
    var nullableInteger: Int?
}

#else

protocol ExampleSchemaProtocol {
    var string: String { get }
    var date: Date { get }
    var double: Double { get }
    var integer: Int { get }
    var nullableString: String? { get }
    var nullableDate: Date? { get }
    var nullableDouble: Double? { get }
    var nullableInteger: Int? { get }
}

final class ExampleSchema: SchemaRepresentable {
    
    static var _schemaName: StaticString { "example_schema" }
    
    static func _migrate(as current: Storage.ModelMigrationBuilder<ExampleSchema>) -> Storage.ModelOperation<ExampleSchema>? {
        try? current.versioned(.latest("example_schema", .attribute(.string, named: "string")))
    }
    
    static func _attributeMetadatas(filteredBy name: String?) -> [Storage.AttributeMetadata] {
        let attrs = [
            AttributeMetadata(name: "string", type: .string, nullable: false),
            AttributeMetadata(name: "date", type: .date, nullable: false),
            AttributeMetadata(name: "double", type: .float, nullable: false),
            AttributeMetadata(name: "integer", type: .integer, nullable: false),
            AttributeMetadata(name: "nullableString", type: .string, nullable: true),
            AttributeMetadata(name: "nullableDate", type: .date, nullable: true),
            AttributeMetadata(name: "nullableDouble", type: .float, nullable: true),
            AttributeMetadata(name: "nullableInteger", type: .integer, nullable: true)
        ]
        
        guard let name  else { return attrs }
        guard let found = attrs.first(where: { $0.name == name }) else { return [AttributeMetadata]() }
        return [found]
    }
    
    typealias Conformant = ExampleSchemaProtocol
    @Attribute var string: String = "<Default Value>"
    @Attribute var date: Date = Date()
    @Attribute var double: Double = 99
    @Attribute var integer: Int = 1
    @Attribute var nullableString: String?
    @Attribute var nullableDate: Date?
    @Attribute var nullableDouble: Double?
    @Attribute var nullableInteger: Int?
    
    
}
#endif
