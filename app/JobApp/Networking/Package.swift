// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "Networking",
	platforms: [.iOS(.v17), .macOS(.v14)],
	products: [
		.library(
			name: "Networking",
			targets: ["Networking"]
		)
	],
	targets: [
		.target(
			name: "Networking"
		)
	]
)
