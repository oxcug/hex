//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import XCTest
import Storage

class Test_Upsert_ModelOperations: XCTestCase {
    
//    let model: Model<ExampleSchema> = {
//       let value = ExampleSchema.init()
//        value.nullableString = "not nil!"
//        return Model(with: value)
//    }()

//    func testUpsert() throws {
//        try model
//            .upsert()
//            .commit(using: .default)
//            .sync()
//
//        let queryResult = try Model<ExampleSchema>
//            .findAll()
//            .commit(using: .default)
//            .sync()
//
//        let result = queryResult.first
//        XCTAssertNotNil(result)
//        XCTAssertEqual(result?.nullableString, "not nil!")
//    }
}

class Test_Query_Operation: XCTestCase {
    
    let model: Model<ExampleSchema> = {
       let value = ExampleSchema.init()
        value.string = "example"
        value.double = 500
        return Model(with: value)
    }()
    
    func testQuery() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

        let queryResult = try Model<ExampleSchema>
            .find(where: Predicate(lhs: .columnSymbol("string"), op: .equals, rhs: .literalValue("example")))
            .commit(using: .default)
            .sync()

        let result = queryResult.first
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.string, "example")
    }
    
    
    func testAndQuery() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

        let queryResult = try Model<ExampleSchema>
                    .find(where: Predicate(lhs: .subPredicate(Predicate(lhs: .columnSymbol("string"), op: .equals, rhs: .literalValue("example"))),
                                           op: .and,
                                           rhs: .subPredicate(Predicate(lhs: .columnSymbol("double"), op: .equals, rhs: .literalValue(500)))))
            .commit(using: .default)
            .sync()

        let result = queryResult.first
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.string, "example")
    }
    
    func testAndQueryNOT() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()

        let queryResult = try Model<ExampleSchema>
            .find(where: Predicate(lhs: .columnSymbol("string"), op: .notEquals, rhs: .literalValue("exampleNOT")))
            .commit(using: .default)
            .sync()

        let result = queryResult.first
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.string, "example")
    }
    
    func testModelDoubleValue() throws {
        try model
            .upsert()
            .commit(using: .default)
            .sync()
        
        let queryResult = try Model<ExampleSchema>
            .find(where: Predicate(lhs: .columnSymbol("double"), op: .greaterThan, rhs: .literalValue(0.0)))
            .commit(using: .default)
            .sync()

        let result = queryResult.first
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.double, 500.0)
    }
}
