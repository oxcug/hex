//
//  File.swift
//  
//
//  Created by Caleb Jonas on 5/14/24.
//

import XCTest
import Storage
import Foundation

class Test_Date_Column: StorageTestCase {
    
    open var date: Date = .distantPast

    var entity: Model<ExampleSchema>!
    
    override func setUpWithError() throws {
        let newObj = ExampleSchema()
        newObj.date = .distantFuture
        
        try Model<ExampleSchema>(with: newObj)
            .upsert()
            .commit(using: config)
            .sync()
        
        let result = try Model<ExampleSchema>
            .findAll()
            .commit(using: config)
            .sync()
        let out = result.first
        
        XCTAssertNotNil(out)
        entity = out
    }
    
    func test() {
        XCTAssertEqual(entity.date, Date.distantFuture)
    }
}
