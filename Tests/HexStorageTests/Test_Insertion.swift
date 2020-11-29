import XCTest
import HexStorage

class Test_ModelOperations: XCTestCase {
    
    let model = Example()
    
    func testUpsert() {
        XCTAssertNoThrow(
            try model
                .upsert()
                .commit(using: .default)
                .sync()
        )

        XCTAssertNoThrow(
            try Example
                .findAll()
                .commit(using: .default)
                .sync()
        )
    }
}
