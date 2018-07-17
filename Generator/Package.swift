// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FactoryGenerator",
    dependencies: [
        .package(url: "https://github.com/behrang/YamlSwift.git", .upToNextMinor(from: "3.4.3")),
        .package(url: "https://github.com/jpsim/SourceKitten.git", .upToNextMinor(from: "0.21.0")),
        .package(url: "https://github.com/Kuniwak/MirrorDiffKit.git", from: "3.0.1"),
        .package(url: "https://github.com/kylef/Commander.git", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMinor(from: "0.9.1")),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.4.0")
    ],
    targets: [
        .target(
            name: "FactoryGenerator",
            dependencies: [
                "Commander",
                "Core",
                "Generator",
                "Parser",
                "PathKit"
            ]
        ),
        .target(
            name: "Core",
            dependencies: [
                "PathKit",
                "Yaml"
            ]
        ),
        .target(
            name: "Parser",
            dependencies: [
                "Core",
                "SourceKittenFramework"
            ]
        ),
        .target(
            name: "Generator",
            dependencies: [
                "Core",
                "PathKit",
                "StencilSwiftKit"
            ]
        ),
        .testTarget(
            name: "ParserTests",
            dependencies: [
                "Parser",
                "MirrorDiffKit"
            ],
            path: "Tests/ParserTests"
        ),
        .testTarget(
            name: "GeneratorTests",
            dependencies: [
                "Generator",
                "MirrorDiffKit"
            ],
            path: "Tests/GeneratorTests"
        )
    ]
)
