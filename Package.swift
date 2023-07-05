// swift-tools-version: 5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Storage",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [        
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b")
    ],
    targets: [
        .target(name: "Storage", dependencies: ["StorageMacros"]),
        .macro(name: "StorageMacros", dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
        ]),
        .testTarget(name: "StorageTests", dependencies: ["Storage"]),
        .testTarget(name: "StorageMacrosTests", dependencies: [
            "StorageMacros",
            .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
        ])
    ]
)
