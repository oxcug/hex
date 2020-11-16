// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Hex Storage",
    products: [
        .library(name: "HexStorage", targets: ["HexStorage"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "HexStorage", dependencies: []),
        .testTarget(name: "HexStorageTests", dependencies: [ .target(name: "HexStorage") ]),
    ]
)
