//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/7/23.
//

import Foundation
import XCTest
import Storage

#if swift(<5.9)
final class Demo {
    @Attribute var ID: Int
    @Attribute var Name: String
    @Attribute var Hint: String
}

extension Demo: SchemaRepresentable {
    typealias Conformant = DemoProtocol
    
    static var _schemaName: StaticString {
        "demo"
    }
    
    static func _attributeMetadatas(filteredBy name: String?) -> [AttributeMetadata] {
        guard let name else {
            return [AttributeMetadata(name: "ID", type: .integer, nullable: false, transformer: nil),
                    AttributeMetadata(name: "Name", type: .string, nullable: false, transformer: nil),
                    AttributeMetadata(name: "Hint", type: .string, nullable: false, transformer: nil)]
        }
        switch name {
        case "ID":
            return [AttributeMetadata(name: "ID", type: .integer, nullable: false, transformer: nil)]
        case "Name":
            return [AttributeMetadata(name: "Name", type: .string, nullable: false, transformer: nil)]
        case "Hint":
            return [AttributeMetadata(name: "Hint", type: .string, nullable: false, transformer: nil)]
        default:
            return []
        }
    }
    
    static func _migrate(as current: ModelMigrationBuilder<Demo>) -> ModelOperation<Demo>? {
        try? current.versioned(.latest("demo", .attribute(.string, named: "string")))
    }
}

protocol DemoProtocol {
    var ID: Int {
        get
    }
    var Name: String {
        get
    }
    var Hint: String {
        get
    }
}
#else
@Schema
final class Demo {
    var ID: Int
    var Name: String
    var Hint: String
}
#endif

class Test_ReadExistingDB: XCTestCase {
    
    enum SetupError: Error { case cannotFindExistingDBURL }
    
    var conf: Configuration!
    
    override func setUpWithError() throws {
        let kv = DatabaseBackedKeyValueStore.self
        
        #if os(WASI)
        let url = URL(string: "existing.sqlite")
        #else
        let url = Bundle.module.url(forResource: "existing", withExtension: "sqlite")
        #endif
        
        guard let url else { throw SetupError.cannotFindExistingDBURL }
        self.conf = try Configuration(keyValueStore: kv, connections: [.file(url: url, .readOnly)])
    }
    
    func testRead() throws {
        let result = try Model<Demo>
            .findAll()
            .commit(using: conf)
            .sync()
        XCTAssertGreaterThan(result.count, 0)
    }
}
