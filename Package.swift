// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UniversalUI",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "UniversalUI",
            targets: ["UniversalUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "UniversalUI",
            dependencies: []),
        .testTarget(
            name: "UniversalUITests",
            dependencies: ["UniversalUI"]),
    ]
)
