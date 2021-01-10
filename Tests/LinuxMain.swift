import XCTest

import WasmerTests

var tests = [XCTestCaseEntry]()
tests += WasmerTests.allTests()
XCTMain(tests)
