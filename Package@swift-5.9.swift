// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Storage",
    platforms: [.macOS(.v13), .iOS(.v17)],
    products: [
        .library(name: "Storage", targets: ["Storage"]),
    ],
    dependencies: [        
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
    ],
    targets: [
        .macro(
            name: "StorageMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "CSQLite"),
        .target(name: "Storage", dependencies: [
            "CSQLite",
            .target(name: "StorageMacros")
        ]),
        .testTarget(name: "StorageTests", dependencies: ["Storage"], resources: [.copy("existing.sqlite")]),
        .testTarget(name: "StorageMacrosTests", dependencies: [
            "StorageMacros",
            .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
        ])
    ]
)
