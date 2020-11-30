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

        let out: [Example] = try? Example
            .findAll()
            .commit(using: .default)
            .sync()
        
        XCTAssertEqual(out.count, 1)
    }
}
