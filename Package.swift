// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MosaicGrid",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "MosaicGrid",
            targets: ["MosaicGrid"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MosaicGrid",
            dependencies: [],
            path: "MosaicGrid/Classes"
        ),
       .testTarget(
           name: "MosaicGridTests",
           dependencies: [
               "MosaicGrid"
           ],
           path: "Example/Tests",
           exclude: ["Info.plist"]
       )
    ]
)
