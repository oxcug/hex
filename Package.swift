// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "HexStorage",
    products: [
        .library(name: "HexStorage", targets: ["HexStorage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/PureSwift/SwiftFoundation.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "HexStorage", dependencies: [
            .product(name: "SwiftFoundation", package: "SwiftFoundation")
        ]),
        .testTarget(name: "HexStorageTests", dependencies: [
            .target(name: "HexStorage")
        ]),
    ]
)
