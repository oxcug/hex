import XCTest
import HexStorage

class StorageTestCase: XCTestCase {
    
    let config = Configuration.default
}

class BaseColumnStorageTestCase: StorageTestCase {
    
    public var columnName: String { fatalError("") }
    
    public var metadata: AttributeMetadata! = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        guard let col = Example.column(named: columnName) else {
            XCTFail()
            return
        }
        
        metadata = col
    }
}
