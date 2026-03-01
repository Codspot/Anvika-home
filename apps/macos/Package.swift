// swift-tools-version: 6.2
// Package manifest for the Anvika macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "Anvika",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "AnvikaIPC", targets: ["AnvikaIPC"]),
        .library(name: "AnvikaDiscovery", targets: ["AnvikaDiscovery"]),
        .executable(name: "Anvika", targets: ["Anvika"]),
        .executable(name: "anvika-mac", targets: ["AnvikaMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/AnvikaKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "AnvikaIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "AnvikaDiscovery",
            dependencies: [
                .product(name: "AnvikaKit", package: "AnvikaKit"),
            ],
            path: "Sources/AnvikaDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "Anvika",
            dependencies: [
                "AnvikaIPC",
                "AnvikaDiscovery",
                .product(name: "AnvikaKit", package: "AnvikaKit"),
                .product(name: "AnvikaChatUI", package: "AnvikaKit"),
                .product(name: "AnvikaProtocol", package: "AnvikaKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/Anvika.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "AnvikaMacCLI",
            dependencies: [
                "AnvikaDiscovery",
                .product(name: "AnvikaKit", package: "AnvikaKit"),
                .product(name: "AnvikaProtocol", package: "AnvikaKit"),
            ],
            path: "Sources/AnvikaMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "AnvikaIPCTests",
            dependencies: [
                "AnvikaIPC",
                "Anvika",
                "AnvikaDiscovery",
                .product(name: "AnvikaProtocol", package: "AnvikaKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
