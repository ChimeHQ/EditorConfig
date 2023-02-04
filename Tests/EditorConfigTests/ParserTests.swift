import XCTest
@testable import EditorConfig

final class ParserTests: XCTestCase {
	func testParsePairs() throws {
		let input = """
a = b
c= d
e =f
g=h
  i  =\tj\t
"""
		let statements = try Parser().parseStatements(input)

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
		let statements = try Parser().parseStatements(input)

		let expected: [Statement] = [
			.sectionHeader("a"),
			.sectionHeader("b"),
			.sectionHeader("c"),
			.sectionHeader("d  "),
		]

		XCTAssertEqual(statements, expected)
	}

	func testParseSections() throws {
		let input = """
[*]
indent_style = tab
[.]
indent_style = space
"""

		let rules = try Parser().parse(input)

		let expected = ConfigurationRules(root: false, sections: [
			.init(pattern: "*", configuration: Configuration(indentStyle: .tab)),
			.init(pattern: ".", configuration: Configuration(indentStyle: .space)),
		])

		XCTAssertEqual(rules, expected)
	}
}
