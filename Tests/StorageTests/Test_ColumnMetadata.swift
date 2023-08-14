///
/// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

class Test_ExampleModel_Schema: StorageTestCase {
    
    func testName() {
        XCTAssertEqual(ExampleSchema._schemaName.description, "example_schema")
    }
}

class Test_String_Column: BaseColumnStorageTestCase {
    
    override var attributeName: String { "string" }
    
    func testString() {
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.name, attributeName)
        XCTAssertEqual(metadata.type, .string)
        XCTAssertFalse(metadata.nullable)
    }
}

class Test_NullableString_Column: BaseColumnStorageTestCase {
    
    override var attributeName: String { "nullableString" }
    
    func testNullableString() {
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.name, attributeName)
        XCTAssertEqual(metadata.type, .string)
        XCTAssertTrue(metadata.nullable)
    }
}
