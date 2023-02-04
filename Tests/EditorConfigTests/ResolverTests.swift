import XCTest
@testable import EditorConfig

final class ResolverTests: XCTestCase {
	lazy var tmpDir = FileManager.default
		.temporaryDirectory
		.appendingPathComponent("EditorConfigTests", isDirectory: true)

	override func setUp() async throws {
		try? FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
	}

	func testResolveSingleFile() throws {
		let rootConfig = Configuration(indentStyle: .tab)

		let configURL = tmpDir.appendingPathComponent(".editorconfig", isDirectory: false)

		try rootConfig
			.render(headerPattern: "*")
			.write(to: configURL, atomically: true, encoding: .utf8)

		let resolver = Resolver()

		let fileURL = tmpDir.appendingPathComponent("somefile")

		let configuration = try resolver.configuration(for: fileURL)

		XCTAssertEqual(configuration, rootConfig)
	}
}
