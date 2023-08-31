///
/// Copyright © 2021-2023 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/benefic-org/storage/blob/master/LICENSE

import Foundation

protocol DatabaseBackedKeyValueProtocol {
    var lookup_key: String { get }
    var stored_value: String? { get }
    var scope: String? { get }
}

struct DatabaseBackedKeyValue: SchemaRepresentable, DatabaseBackedKeyValueProtocol {
    
    typealias Conformant = DatabaseBackedKeyValueProtocol
    
    static var _schemaName: StaticString { "_kvstore" }
    
    static func _migrate(as current: ModelMigrationBuilder<DatabaseBackedKeyValue>) -> ModelOperation<DatabaseBackedKeyValue>? {
        try? current.versioned(
            .latest(Self._schemaName,
                    .attribute(.string, named: "lookup_key"),
                    .attribute(.string, named: "stored_value"),
                    .attribute(.string, named: "scope")
            )
        )
    }
    
    static func _attributeMetadatas(filteredBy name: String?) -> [AttributeMetadata] {
        [
			.init(name: "lookup_key", type: .string, nullable: false, traits: [.primaryKey]),
            .init(name: "stored_value", type: .string, nullable: true),
            .init(name: "scope", type: .string, nullable: true)
        ]
    }
    
	@Attribute(traits: [.primaryKey]) var lookup_key: String
    
    @Attribute var stored_value: String?
    
    @Attribute var scope: String?
    
    init(lookup_key: String, stored_value: String? = nil, scope: String? = nil) {
        self.lookup_key = lookup_key
        self.stored_value = stored_value
        self.scope = scope
    }
}

public struct DatabaseBackedKeyValueStore: KeyValueStorageProtocol {

    let scope: (any KeyValueStorageScope)?
    
    weak var config: Configuration!

    public init(config: Configuration, scope: (any KeyValueStorageScope)?) {
        self.config = config
        self.scope = scope
        try! config.register(schema: DatabaseBackedKeyValue.self)
    }
    
    public func getObject<T>(forKey: String) -> T? where T : AttributeValue {
        let x = try! Model<DatabaseBackedKeyValue>
            .find(where: Predicate(lhs: .columnSymbol("lookup_key"), op: .equals, rhs: .literalValue(forKey)))
            .commit(using: config)
            .sync()
        return x.first?.attributeValueStorage["stored_value"] as? T
    }
    
    public func set<T>(object: T?, forKey: String) where T : AttributeValue {
        try! Model(with: DatabaseBackedKeyValue(lookup_key: forKey, stored_value: object as? String))
            .upsert()
            .commit(using: config)
            .sync()
    }
    
    public func reset(scope: (any KeyValueStorageScope)?) {
        try! Model<DatabaseBackedKeyValue>
            .findAll()
            .commit(using: config)
            .sync().forEach {
                try $0.delete()
                    .commit(using: config)
                    .sync()
            }
    }
}
