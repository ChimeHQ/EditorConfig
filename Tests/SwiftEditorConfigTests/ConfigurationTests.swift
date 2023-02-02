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
}
