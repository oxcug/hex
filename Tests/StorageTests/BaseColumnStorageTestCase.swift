//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

class StorageTestCase: XCTestCase {
    
    let config = Configuration.default
}

class BaseColumnStorageTestCase: StorageTestCase {
    
    public var columnName: String { fatalError("") }
    
    public var metadata: AttributeMetadata! = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        guard let col = ExampleModel.column(named: columnName) else {
            XCTFail()
            return
        }
        
        metadata = col
    }
}
