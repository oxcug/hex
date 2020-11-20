import XCTest
import HexStorage

class Test_ModelOperations: XCTestCase {
    
    let model = Example(for: .default)
    
    func testUpsert() {
        XCTAssertNoThrow(
            model
                .upsert()
                .commit(using: .default)
        )
        
//        model.operationBuilder
//            .find(.all)
//            .commit(using: .default)
    }
}
