// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "example",
    dependencies: [
        .package(
            path: "../../blusher-brc-plugin",
        ),
    ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies: ["ImageResources"],
            swiftSettings: [
                .unsafeFlags(["-I../../.build/debug/Modules"]),
                .unsafeFlags(["-I../../.build/release/Modules"]),
            ],
            linkerSettings: [
                .linkedLibrary("Blusher"),
                .unsafeFlags(["-L../../.build/debug"]),
                .unsafeFlags(["-L../../.build/release"]),
            ]
        ),
        .target(
            name: "ImageResources",
            path: "Resources/ImageResources",
            swiftSettings: [
                .unsafeFlags(["-I../../.build/debug/Modules"]),
            ],
            linkerSettings: [
                .linkedLibrary("Blusher"),
                .unsafeFlags(["-L../../.build/debug"]),
                .unsafeFlags(["-L.blusher/lib", "-lResources"]),
            ],
            plugins: [
                .plugin(name: "BlusherBRCPlugin", package: "blusher-brc-plugin"),
            ]
        ),
    ]
)
