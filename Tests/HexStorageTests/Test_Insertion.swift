import XCTest
import HexStorage

class Test_Upsert_ModelOperations: XCTestCase {
    
<<<<<<< HEAD
    let model = ExampleModel()

=======
    let model = Example()
    
>>>>>>> b478d27cfbdffa9632629d511abfe028bbd6d7c1
    func testUpsert() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

<<<<<<< HEAD
        let queryResult: [ExampleModel] = try ExampleModel
=======
        let queryResult: [Example] = try Example
>>>>>>> b478d27cfbdffa9632629d511abfe028bbd6d7c1
            .findAll()
            .commit(using: .default)
            .sync()
        
        XCTAssertEqual(queryResult.count, 1)
<<<<<<< HEAD
        XCTAssertEqual(queryResult,  [model])
=======
>>>>>>> b478d27cfbdffa9632629d511abfe028bbd6d7c1
    }
}
