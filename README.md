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

let flc = FuzzyLogicController(rules: ruleBase, settings: .init(implication: .mamdani))

flc.consequenceGrade(for: 50, usingSingletonFact: (8.8, 42))  // result is 0.675
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

## API Reference

API Reference automatically collected with `jazzy` is published [here](https://allexks.github.io/FuzzyKit) with each new release.

## `FuzzySets` Module

* `protocol FuzzySet`: This abstraction requires a fuzzy set to provide a `grade(forElement:)` method which accepts a parameter of an `associatedtype Universe` and returns its membership `Grade` in the set. There are 3 provided concrete implementations in this module:
    1. `struct AnyFuzzySet` - allows type erasure. It only stores a `MembershipFunction` and has non-mutable methods.
    2. `struct IterableFuzzySet` - stores a `MembershipFunction` as well as a `Sequence` of elements of the associated type `Universe`. Implements `Sequence` so that it can easily be iterated over them. The elements of the iteration over an `IterableFuzzySet` are `struct`s containing `grade` and `element` properties. It has non-mutable methods only.
    3. `struct DiscreteMutableFuzzySet` - it is "discrete" because it doesn't stores a `MembershipFunction` but instead keeps its elements and their grade in a `Dictionary`, and it is "mutable" because it contains mutable equivalents of all other methods that operate over the set (including `subscript`). A default value of `0` is returned for the grade of an element that is not in the dictionary (a different default value can be provided as well).

* `protocol FuzzySetOperations` - all 3 concrete types implement it. It requires the following methods that operate on fuzzy sets:
    * `alphaCut(_:alpha:)`

    * `complement(method:)`

    * `intersection(_:method:)`

    * `union(_:method:)`

    * `difference(_:method:)`

    * `symmetricDifference(_:method:)`

    * `power(_:n:)`

    * `appliedCustomFunction(_:function:)`

## License

[MIT](LICENSE)

