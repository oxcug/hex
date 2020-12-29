import XCTest
import HexStorage

class Test_ExampleModel_Schema: StorageTestCase {
    
    func testName() {
        XCTAssertEqual(String(describing: ExampleModel.name), "example")
    }
}

class Test_String_Column: BaseColumnStorageTestCase {
    
    override var columnName: String { "string" }
    
    func testString() {
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.name, columnName)
        XCTAssertEqual(metadata.type, .string)
        XCTAssertFalse(metadata.nullable)
    }
}

class Test_NullableString_Column: BaseColumnStorageTestCase {
    
    override var columnName: String { "nullableString" }
    
    func testNullableString() {
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.name, columnName)
        XCTAssertEqual(metadata.type, .string)
        XCTAssertTrue(metadata.nullable)
    }
}
