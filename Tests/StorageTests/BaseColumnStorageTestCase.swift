//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

class StorageTestCase: XCTestCase {
    
    let config = Configuration.default
}

class BaseColumnStorageTestCase: StorageTestCase {
    
    public var attributeName: String { fatalError("") }
    
    public var metadata: AttributeMetadata! = nil
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        let attrs = ExampleSchema._attributeMetadatas(filteredBy: attributeName)
        guard let attr = attrs.first else {
            XCTFail()
            return
        }
        
        metadata = attr
    }
}
