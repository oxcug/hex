import XCTest

class Test_ModelOperations: XCTestCase {
    
    let model = Example(for: .default)
    
    func testUpsert() {
        _ = model.operationBuilder
            .upsert()
    }
}
