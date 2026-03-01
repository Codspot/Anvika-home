// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AnvikaKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "AnvikaProtocol", targets: ["AnvikaProtocol"]),
        .library(name: "AnvikaKit", targets: ["AnvikaKit"]),
        .library(name: "AnvikaChatUI", targets: ["AnvikaChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "AnvikaProtocol",
            path: "Sources/AnvikaProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "AnvikaKit",
            dependencies: [
                "AnvikaProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/AnvikaKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "AnvikaChatUI",
            dependencies: [
                "AnvikaKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/AnvikaChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "AnvikaKitTests",
            dependencies: ["AnvikaKit", "AnvikaChatUI"],
            path: "Tests/AnvikaKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
