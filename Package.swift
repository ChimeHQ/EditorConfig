// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "SwiftEditorConfig",
	products: [
		.library(name: "SwiftEditorConfig", targets: ["SwiftEditorConfig"]),
	],
	dependencies: [
	],
	targets: [
		.target(name: "SwiftEditorConfig", dependencies: []),
		.testTarget(name: "SwiftEditorConfigTests", dependencies: ["SwiftEditorConfig"]),
	]
)
