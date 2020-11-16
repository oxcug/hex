import XCTest
import HexStorage

class Test_ExampleModel_Table: StorageTestCase {
    
    func testName() {
        XCTAssertEqual(Example.tableName(for: config), (config.tableNamePrefix ?? "") + "Example")
    }
}

class Test_String_Column: BaseColumnStorageTestCase {
    
    override var columnName: String { "string" }
    
    func testString() {
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.name, columnName)
        XCTAssertEqual(metadata.valueType, .string)
        XCTAssertFalse(metadata.nullable)
    }
}

class Test_NullableString_Column: BaseColumnStorageTestCase {
    
    override var columnName: String { "nullableString" }
    
    func testNullableString() {
        XCTAssertNotNil(metadata)
        XCTAssertEqual(metadata.name, columnName)
        XCTAssertEqual(metadata.valueType, .string)
        XCTAssertTrue(metadata.nullable)
    }
}
