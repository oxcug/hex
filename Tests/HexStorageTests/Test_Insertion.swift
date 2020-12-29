import XCTest
import HexStorage

class Test_Upsert_ModelOperations: XCTestCase {
    
    let model = ExampleModel()

    func testUpsert() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

        let queryResult: [ExampleModel] = try ExampleModel
            .findAll()
            .commit(using: .default)
            .sync()
        
        XCTAssertEqual(queryResult.count, 1)
        XCTAssertEqual(queryResult,  [model])
    }
}
