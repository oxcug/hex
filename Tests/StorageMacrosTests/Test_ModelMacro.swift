//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/3/23.
//

import XCTest
import SwiftSyntaxMacrosTestSupport
@testable import StorageMacros

@available(swift 5.9)
class Test_ModelMacro: XCTestCase {
    
    func test() {
        assertMacroExpansion("""
@Schema
struct FooSchema {
var x: Double
}
""", expandedSource: """
struct FooSchema {
    @Attribute
    var x: Double
    static var _schemaName: StaticString {
        "foo_schema"
    }
    static func _attributeMetadatas(filteredBy name: String?) -> [AttributeMetadata] {
        guard let name else {
            return [AttributeMetadata(name: "x", type: .float, nullable: false, transformer: nil)]
        }
        switch name {
        case "x":
            return [AttributeMetadata(name: "x", type: .float, nullable: false, transformer: nil)]
        default:
            return []
        }
    }
    static func _migrate(as current: ModelMigrationBuilder<FooSchema>) -> ModelOperation<FooSchema>? {
        nil
    }
}
extension FooSchema: SchemaRepresentable {
}

""", macros: ["Schema": StorageMacros.SchemaMacro.self])
    }
}
