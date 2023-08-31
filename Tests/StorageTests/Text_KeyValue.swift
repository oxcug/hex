//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

class BaseKeyValueTestCase: XCTestCase {
    override func setUpWithError() throws {
        /// Calling `removePersistentDomain` will reset all key/value pairs giving all tests that use the `KeyValue` logic a clean state.
        Configuration.default.kv.reset(scope: nil)
    }
}

class Test_KeyValue_ReadWrite: BaseKeyValueTestCase {
    
    @KeyValue(.default, key: "aBoolean", default: "Hello, World")
    var str: String
    
    func testString() {
        XCTAssertEqual(str, "Hello, World")
        str = "athing"
        XCTAssertEqual(str, "athing")
    }
	
	func testStringWriteTwice() {
        XCTAssertEqual(str, "Hello, World")
        str = "athing"
        XCTAssertEqual(str, "athing")
		str = "a special thing"
		XCTAssertEqual(str, "a special thing")
    }
}
