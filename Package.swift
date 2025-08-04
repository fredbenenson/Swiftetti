// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftetti",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)  // Add macOS support but with newer version
    ],
    products: [
        .library(
            name: "Swiftetti",
            targets: ["Swiftetti"]),
    ],
    targets: [
        .target(
            name: "Swiftetti",
            dependencies: []),
        .testTarget(
            name: "SwiftettiTests",
            dependencies: ["Swiftetti"]),
    ]
)