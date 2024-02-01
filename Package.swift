// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MosaicGrid",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "MosaicGrid",
            targets: ["MosaicGrid"]
        )
    ],
    dependencies: [
        // uncomment code below to test
       .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
       .package(url: "https://github.com/Quick/Nimble.git", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "MosaicGrid",
            dependencies: [],
            path: "MosaicGrid/Classes"
        ),
        // uncomment code below to test
       .testTarget(
           name: "MosaicGridTests",
           dependencies: [
               "MosaicGrid", "Quick", "Nimble"
           ],
           path: "Example/Tests",
           exclude: ["Info.plist"]
       )
    ]
)
