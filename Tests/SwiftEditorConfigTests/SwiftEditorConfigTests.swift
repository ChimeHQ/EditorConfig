import XCTest
@testable import SwiftEditorConfig

final class SwiftEditorConfigTests: XCTestCase {
	func testParsePairs() throws {
		let input = """
a = b
c= d
e =f
g=h
  i  =\tj\t
"""
		let statements = try Parser().parse(input)

		let expected: [Statement] = [
			.pair("a", "b"),
			.pair("c", "d"),
			.pair("e", "f"),
			.pair("g", "h"),
			.pair("i", "j"),
		]

		XCTAssertEqual(statements, expected)
	}

	func testParseHeaders() throws {
		let input = """
[a]
  [b]
\t[c]
[d  ]
"""
		let statements = try Parser().parse(input)

		let expected: [Statement] = [
			.sectionHeader("a"),
			.sectionHeader("b"),
			.sectionHeader("c"),
			.sectionHeader("d  "),
		]

		XCTAssertEqual(statements, expected)

	}
}
