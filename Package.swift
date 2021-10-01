// swift-tools-version:5.3
import PackageDescription

// CSQLite3 Target (module map needed for linux)
#if os(Linux) || os(OSX)
let cSQLite: Target = .systemLibrary(name: "CSQLite3",
                                    path: "Libraries/CSQLite3",
                                    providers: [
                                        .brew(["sqlite"]),
                                        .apt(["libsqlite3-dev"])
                                    ])
#endif

// HexStorage Target
let targets: [Target]
let dependencies: [Package.Dependency]
let hexStorage: Target

#if os(Linux) || os(OSX)
dependencies = []
hexStorage = .target(name: "Storage", dependencies: [.target(name: "CSQLite3")])
targets = [hexStorage, cSQLite]
#elseif os(WASI)
dependencies = [.package(url: "https://github.com/PureSwift/SwiftFoundation.git", from: "3.0.0")]
hexStorage = .target(name: "Storage", dependencies: [.target(name: "SwiftFoundation")])
targets = [hexStorage]
#else
#error("Unknown Platform!")
#endif

let package = Package(
    name: "hex",
    platforms: [ .iOS(.v10), .watchOS(.v5), .macOS(.v10_13) ],
    products: [
        .library(name: "Hex", targets: ["Storage", "Image"]),
    ],
    dependencies: dependencies,
    targets: targets + [
        .target(name: "Image", resources: [
            .copy("ImageDifference.metal")
        ]),
        .testTarget(name: "ImageTests", dependencies: ["Image"]),
        .testTarget(name: "StorageTests", dependencies: [
            .target(name: "Storage")
        ]),
    ]
)
