//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

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
        
        XCTAssertEqual(queryResult, [model])
    }
}
