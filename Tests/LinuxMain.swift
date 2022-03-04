import XCTest

import DebugTests

var tests = [XCTestCaseEntry]()
tests += DebugTests.allTests()
XCTMain(tests)
