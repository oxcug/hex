//
//  File.swift
//  
//
//  Created by Caleb on 3/28/21.
//

import XCTest
import HexStorage

class BaseKeyValueTestCase: XCTestCase {
    override func setUpWithError() throws {
        /// Calling `removePersistentDomain` will reset all key/value pairs giving all tests that use the `KeyValue` logic a clean state.
        UserDefaults().removePersistentDomain(forName: "Tests")
    }
}

class Test_KeyValue_ReadWrite: BaseKeyValueTestCase {
    
    @KeyValue(.default, key: "boolean", default: false)
    var boolean: Bool
    
    @NullableKeyValue(.default, key: "boolean")
    var nullableBoolean: Bool?

    func testBool() {
        XCTAssertFalse(boolean) // default value is false (see `boolean` property above).
        boolean = true
        XCTAssertTrue(boolean)
        boolean = false
        XCTAssertFalse(boolean)
    }
    
    func testNullableBool() {
        XCTAssertNil(nullableBoolean) // default value is nil.
        nullableBoolean = true
        XCTAssertTrue(boolean)
        nullableBoolean = false
        XCTAssertFalse(boolean)
        nullableBoolean = nil
        XCTAssertNil(nullableBoolean)
    }
}
