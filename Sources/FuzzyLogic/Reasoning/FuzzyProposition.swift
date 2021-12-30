import FuzzySets

public protocol FuzzyProposition {
    associatedtype U
    func apply(_ u: U, settings: OperationSettings) -> Grade
}

public extension FuzzyProposition {
    func callAsFunction(_ u: U, settings: OperationSettings = .init()) -> Grade {
        apply(u, settings: settings)
    }
}

extension AnyFuzzySet: FuzzyProposition {
    public func apply(_ u: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: u)
    }
}

extension IterableFuzzySet: FuzzyProposition {
    public func apply(_ u: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: u)
    }
}

extension DiscreteMutableFuzzySet: FuzzyProposition {
    public func apply(_ u: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: u)
    }
}
