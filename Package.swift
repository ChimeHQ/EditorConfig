// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "EditorConfig",
	products: [
		.library(name: "EditorConfig", targets: ["EditorConfig"]),
	],
	dependencies: [
	],
	targets: [
		.target(name: "EditorConfig", dependencies: []),
		.testTarget(name: "EditorConfigTests", dependencies: ["EditorConfig"]),
	]
)
