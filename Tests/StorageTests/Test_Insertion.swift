//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

class Test_Upsert_ModelOperations: XCTestCase {
    
    let model = Model<ExampleSchema>(with: ExampleSchema.init())

    func testUpsert() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

        let queryResult = try Model<ExampleSchema>
            .findAll()
            .commit(using: .default)
            .sync()
        
//        XCTAssertEqual(queryResult.first?.nullableString, model.nullableString)
    }
}
