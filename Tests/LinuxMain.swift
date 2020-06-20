import XCTest

import cliCodegenTests

var tests = [XCTestCaseEntry]()
tests += cliCodegenTests.allTests()
XCTMain(tests)
