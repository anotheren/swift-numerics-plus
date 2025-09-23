// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-numerics-plus",
    products: [
        .library(
            name: "NumericsPlus",
            targets: ["NumericsPlus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "NumericsPlus",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
            ]),
        .testTarget(
            name: "NumericsPlusTests",
            dependencies: ["NumericsPlus"]),
    ]
)
