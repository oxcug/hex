// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Storage", dependencies: []),
        .testTarget(name: "StorageTests", dependencies: ["Storage"])
    ]
)
