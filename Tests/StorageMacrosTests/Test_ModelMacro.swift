//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/3/23.
//

import XCTest
import SwiftSyntaxMacrosTestSupport
@testable import StorageMacros

class Test_ModelMacro: XCTestCase {
    
    func test() {
        assertMacroExpansion("""
@Schema
struct Foo {
var x: Double
}
""", expandedSource: """
struct Foo {
    @Attribute
    var x: Double
}
""", macros: ["Schema": StorageMacros.SchemaMacro.self])
    }
}
