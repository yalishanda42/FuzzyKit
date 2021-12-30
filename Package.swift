// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum SubmoduleName: String {
    case fuzzyKit = "FuzzyKit"
    case fuzzySets = "FuzzySets"
    case fuzzyNumbers = "FuzzyNumbers"
    case fuzzyRelations = "FuzzyRelations"
    case fuzzyLogic = "FuzzyLogic"
    
    var name: String { rawValue }
    var target: String { rawValue }
    var testTarget: String { rawValue + "Tests" }
}

let package = Package(
    name: "FuzzyKit",
    products: [
        .library(
            name: SubmoduleName.fuzzyKit.name,
            targets: [SubmoduleName.fuzzyKit.target]
        ),
        .library(
            name: SubmoduleName.fuzzySets.name,
            targets: [SubmoduleName.fuzzySets.target]
        ),
        .library(
            name: SubmoduleName.fuzzyNumbers.name,
            targets: [SubmoduleName.fuzzyNumbers.target]
        ),
        .library(
            name: SubmoduleName.fuzzyRelations.name,
            targets: [SubmoduleName.fuzzyRelations.target]
        ),
        .library(
            name: SubmoduleName.fuzzyLogic.name,
            targets: [SubmoduleName.fuzzyLogic.target]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: SubmoduleName.fuzzyKit.target,
            dependencies: [
                .target(name: SubmoduleName.fuzzySets.target),
                .target(name: SubmoduleName.fuzzyNumbers.target),
                .target(name: SubmoduleName.fuzzyRelations.target),
                .target(name: SubmoduleName.fuzzyLogic.target),
            ]
        ),
        .target(
            name: SubmoduleName.fuzzySets.target,
            dependencies: [
                .product(name: "RealModule", package: "swift-numerics"),
            ]
        ),
        .testTarget(
            name: SubmoduleName.fuzzySets.testTarget,
            dependencies: [
                .target(name: SubmoduleName.fuzzySets.target)
            ]
        ),
        .target(
            name: SubmoduleName.fuzzyNumbers.target,
            dependencies: [
                .target(name: SubmoduleName.fuzzySets.target),
            ]
        ),
        .testTarget(
            name: SubmoduleName.fuzzyNumbers.testTarget,
            dependencies: [
                .target(name: SubmoduleName.fuzzyNumbers.target),
            ]
        ),
        .target(
            name: SubmoduleName.fuzzyRelations.target,
            dependencies: [
                .target(name: SubmoduleName.fuzzySets.target),
            ]
        ),
        .testTarget(
            name: SubmoduleName.fuzzyRelations.testTarget,
            dependencies: [
                .target(name: SubmoduleName.fuzzyRelations.target),
                .target(name: SubmoduleName.fuzzySets.target),
            ]
        ),
        .target(
            name: SubmoduleName.fuzzyLogic.target,
            dependencies: [
                .target(name: SubmoduleName.fuzzySets.target),
                .target(name: SubmoduleName.fuzzyRelations.target),
            ]
        ),
        .testTarget(
            name: SubmoduleName.fuzzyLogic.testTarget,
            dependencies: [
                .target(name: SubmoduleName.fuzzyLogic.target),
                .target(name: SubmoduleName.fuzzySets.target),
            ]
        ),
    ]
)
