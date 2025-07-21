// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Blusher",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.

        .library(
            name: "Blusher",
            type: .dynamic,
            targets: ["Blusher"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .systemLibrary(
            name: "Swingby",
            path: "swingby",
        ),
        .target(
            name: "Blusher",
            dependencies: ["Swingby"],
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution"])
            ],
        ),
        .testTarget(
            name: "blusherTests",
            dependencies: ["Blusher"]
        ),
    ]
)
