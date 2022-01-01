import FuzzySets

public protocol FuzzyProposition {
    associatedtype Input
    func apply(_ x: Input, settings: OperationSettings) -> Grade
}

public extension FuzzyProposition {
    func callAsFunction(_ x: Input, settings: OperationSettings = .init()) -> Grade {
        apply(x, settings: settings)
    }
}

extension AnyFuzzySet: FuzzyProposition {
    public func apply(_ x: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: x)
    }
}

extension IterableFuzzySet: FuzzyProposition {
    public func apply(_ x: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: x)
    }
}

extension DiscreteMutableFuzzySet: FuzzyProposition {
    public func apply(_ x: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: x)
    }
}
