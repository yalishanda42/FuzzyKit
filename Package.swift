// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FuzzyKit",
    products: [
        .library(
            name: "FuzzyKit",
            targets: ["FuzzyKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "FuzzyKit",
            dependencies: [
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .testTarget(
            name: "FuzzyKitTests",
            dependencies: ["FuzzyKit"]
        ),
    ]
)
