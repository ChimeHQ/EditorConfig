// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "EditorConfig",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
		.macCatalyst(.v13),
		.visionOS(.v1),
	],
	products: [
		.library(name: "EditorConfig", targets: ["EditorConfig"]),
	],
	dependencies: [
		.package(url: "https://github.com/davbeck/swift-glob", from: "0.0.0"),
	],
	targets: [
		.target(
			name: "EditorConfig",
			dependencies: [.product(name: "Glob", package: "swift-glob")]
		),
		.testTarget(name: "EditorConfigTests", dependencies: ["EditorConfig"]),
	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency"),
	.enableUpcomingFeature("DisableOutwardActorInference"),
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
