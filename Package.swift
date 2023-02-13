// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "EditorConfig",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
	products: [
		.library(name: "EditorConfig", targets: ["EditorConfig"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/GlobPattern", branch: "main"),
	],
	targets: [
		.target(name: "EditorConfig", dependencies: ["GlobPattern"]),
		.testTarget(name: "EditorConfigTests", dependencies: ["EditorConfig"]),
	]
)
