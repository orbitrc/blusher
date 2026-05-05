// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "blusher-brc-plugin",
    products: [
        .plugin(
            name: "BlusherBRCPlugin",
            targets: ["BlusherBRCPlugin"]
        ),
    ],
    targets: [
        .plugin(
            name: "BlusherBRCPlugin",
            capability: .buildTool()
        ),
    ]
)
