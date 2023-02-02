import XCTest
@testable import SwiftEditorConfig

final class ConfigurationTests: XCTestCase {
	func testRenderEmptyConfig() throws {
		let config = Configuration()

		let output = config.render()

		let expected = """
root = true

[*]
"""
		XCTAssertEqual(output, expected)
	}

	func testRenderEmptyLeafConfig() throws {
		let config = Configuration()

		let output = config.render(root: false)

		let expected = """
[*]
"""
		XCTAssertEqual(output, expected)
	}

	func testRenderConfigWithIndentStyle() throws {
		let config = Configuration(indentStyle: .space)

		let output = config.render()

		let expected = """
root = true

[*]
indent_style = space
"""
		XCTAssertEqual(output, expected)
	}

	func testRenderConfigWithIndentSize() throws {
		let config = Configuration(indentSize: 4)

		let output = config.render()

		let expected = """
root = true

[*]
indent_size = 4
"""
		XCTAssertEqual(output, expected)
	}
}
