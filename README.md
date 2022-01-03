![Cover photo](Resources/cover.png)

# FuzzyKit

Fuzzy sets and fuzzy logic theory implementations.

![Made for Swift](https://img.shields.io/badge/MADE%20FOR-SWIFT-orange?style=for-the-badge&logo=swift)
![Swift Package Manager supported](https://img.shields.io/badge/SWIFT%20PACKAGE%20MANAGER-SUPPORTED-green?style=for-the-badge&logo=SWIFT)

[![Build & Test](https://github.com/allexks/FuzzyKit/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/allexks/FuzzyKit/actions/workflows/build-and-test.yml)
![License](https://img.shields.io/github/license/allexks/FuzzyKit)

## Example Usage

```swift
import FuzzyKit

enum Funding { case adequate, marginal, inadequate }
enum Staffing { case small, large }
enum Risk { case low, normal, high }

let funding: SimpleLinguisticVariable<Funding, AnyFuzzySet> = [
    .inadequate: .init(membershipFunction: .leftOpen(slopeStart: 15, slopeEnd: 35)),
    .marginal: .init(membershipFunction: .triangular(minimum: 21, peak: 41, maximum: 61)),
    .adequate: .init(membershipFunction: .rightOpen(slopeStart: 55, slopeEnd: 75)),
]

let staffing: SimpleLinguisticVariable<Staffing, AnyFuzzySet> = [
    .small: .init(membershipFunction: .leftOpen(slopeStart: 29, slopeEnd: 69)),
    .large: .init(membershipFunction: .rightOpen(slopeStart: 37, slopeEnd: 77)),
]

let risk: SimpleLinguisticVariable<Risk, AnyFuzzySet> = [
    .low: .init(membershipFunction: .leftOpen(slopeStart: 20, slopeEnd: 40)),
    .normal: .init(membershipFunction: .triangular(minimum: 20, peak: 50, maximum: 80)),
    .high: .init(membershipFunction: .rightOpen(slopeStart: 60, slopeEnd: 80)),
]

let Ø = AnyFuzzySet<Double>.empty

let ruleBase = FuzzyRuleBase {
    funding.is(.adequate) || staffing.is(.small) --> risk.is(.low)
    funding.is(.marginal) && staffing.is(.large) --> risk.is(.normal)
    funding.is(.inadequate) || Ø --> risk.is(.high)
}

let flc = FuzzyLinguisticController(rules: ruleBase, settings: .init(implication: .mamdani))

flc.consequenceGrade(for: 50, usingFact: .singleton((8.8, 42)))  // result is 0.675
```

## Modules

Using the Swift Package Manager, don't forget to add the package as a dependency to your `Package.swift` file:

```diff
dependencies: [
+   .package(url: "https://github.com/allexks/FuzzyKit", .upToNextMajor(from: "0.1.0")),
],
```

To be able to use everything from this package, you can import everything at once using this helper module:

```diff
.target(
    name: "...",
    dependencies: [
+       .product(name: "FuzzyKit", package: "FuzzyKit"),
    ]
),
```

```swift
import FuzzyKit
```

Or alternatively, import only the specific modules needed:

```diff
.target(
    name: "...",
    dependencies: [
+       .product(name: "FuzzySets", package: "FuzzyKit"),
+       .product(name: "FuzzyNumbers", package: "FuzzyKit"),
+       .product(name: "FuzzyRelations", package: "FuzzyKit"),
+       .product(name: "FuzzyLogic", package: "FuzzyKit"),
    ]
),
```

```swift
import FuzzySets
import FuzzyNumbers
import FuzzyRelations
import FuzzyLogic
```

