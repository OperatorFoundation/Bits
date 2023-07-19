// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bits",
    platforms: [
	.macOS(.v13),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Bits",
            targets: ["Bits"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Bits",
            dependencies: ["Datable"]),
        .testTarget(
            name: "BitsTests",
            dependencies: ["Bits"]),
    ],
    swiftLanguageVersions: [.v5]
)
