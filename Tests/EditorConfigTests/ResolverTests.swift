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

	func testPatchnameMatching() throws {
		let resolver = Resolver()

		XCTAssertTrue(try resolver.matches("abc", pattern: "*"))

		XCTAssertTrue(try resolver.matches("abc.py", pattern: "*.py"))
		XCTAssertFalse(try resolver.matches("abc.js", pattern: "*.py"))

		XCTAssertTrue(try resolver.matches("Makefile", pattern: "Makefile"))
		XCTAssertFalse(try resolver.matches("Madefile", pattern: "Makefile"))
		XCTAssertFalse(try resolver.matches("abc/Mafefile", pattern: "Makefile"))

		XCTAssertTrue(try resolver.matches("lib/abc.js", pattern: "lib/**.js"))
		XCTAssertTrue(try resolver.matches("lib/a/bc.js", pattern: "lib/**.js"))
		XCTAssertFalse(try resolver.matches("lib/abc.py", pattern: "lib/**.js"))
		XCTAssertFalse(try resolver.matches("abc.js", pattern: "lib/**.js"))
		XCTAssertFalse(try resolver.matches("lid/abc.js", pattern: "lib/**.js"))
		XCTAssertFalse(try resolver.matches("libabc.js", pattern: "lib/**.js"))
	}

	func testResolveSingleNonMatchingFile() throws {
		let rootConfig = Configuration(indentStyle: .tab)

		let configURL = tmpDir.appendingPathComponent(".editorconfig", isDirectory: false)

		try rootConfig
			.render(headerPattern: "*.js")
			.write(to: configURL, atomically: true, encoding: .utf8)

		let resolver = Resolver()

		let fileURL = tmpDir.appendingPathComponent("somefile.py")

		let configuration = try resolver.configuration(for: fileURL)

		XCTAssertEqual(configuration, Configuration())
	}
}
