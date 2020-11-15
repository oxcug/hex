import XCTest

import hexTests

var tests = [XCTestCaseEntry]()
tests += hexTests.allTests()
XCTMain(tests)
