//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/7/23.
//

import Foundation
import XCTest
import Storage

#if swift(>=5.9)
@Schema
final class Demo {
    var ID: Int
    var Name: String
    var Hint: String
}

class Test_ReadExistingDB: XCTestCase {
    
    
    var conf: Configuration!
    
    override func setUpWithError() throws {
        self.conf = try Configuration(connections: [.file(url: Bundle.module.url(forResource: "existing", withExtension: "sqlite")!, .readOnly)])
    }
    
    func testRead() throws {
        let result = try Model<Demo>
            .findAll()
            .commit(using: conf)
            .sync()
        XCTAssertGreaterThan(result.count, 0)
    }
}
#endif
