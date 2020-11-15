import XCTest
import HexStorage

class StorageTestCase: XCTestCase {
    
    let config = Configuration.default
    
}

class Test_ExampleModel_Table: StorageTestCase {
    
    func testName() {
        XCTAssertEqual(Example.tableName(for: config), (config.tableNamePrefix ?? "") + "Example")
    }
}

class BaseColumnStorageTestCase: StorageTestCase {
    
    var columnName: String { fatalError("") }
    
    var metadata: AttributeMetadata! = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        guard let col = Example.column(for: config, named: columnName) else {
            XCTFail()
            return
        }
        
        metadata = col
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
