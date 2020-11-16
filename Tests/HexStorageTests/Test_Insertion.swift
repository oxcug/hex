import XCTest
import HexStorage

class Test_ModelOperations: XCTestCase {
    
    let model = Example(for: .default)
    
    func testUpsert() {
        model.operationBuilder
            .upsert()
            .delete()
            .commit(using: .default)
    }
}
