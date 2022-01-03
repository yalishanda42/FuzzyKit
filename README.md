![Cover photo](Resources/cover.png)

# FuzzyKit

Fuzzy sets and fuzzy logic theory implementations.

![Made for Swift](https://img.shields.io/badge/MADE%20FOR-SWIFT-orange?style=for-the-badge&logo=swift)
![Swift Package Manager supported](https://img.shields.io/badge/SWIFT%20PACKAGE%20MANAGER-SUPPORTED-green?style=for-the-badge&logo=SWIFT)

[![Build & Test](https://github.com/allexks/FuzzyKit/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/allexks/FuzzyKit/actions/workflows/build-and-test.yml)
![License](https://img.shields.io/github/license/allexks/FuzzyKit)

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