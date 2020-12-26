import XCTest
import HexStorage

class Test_ModelOperations: XCTestCase {
    
    let model = Example()
    
    func testUpsert() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

        let queryResult: [Example] = try Example
            .findAll()
            .commit(using: .default)
            .sync()
        
        XCTAssertEqual(queryResult.count, 1)
    }
}
