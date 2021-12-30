import FuzzySets

public protocol FuzzyStatement {
    associatedtype U
    func apply(_ u: U, settings: OperationSettings) -> Grade
}

public extension FuzzyStatement {
    func callAsFunction(_ u: U, settings: OperationSettings = .init()) -> Grade {
        apply(u, settings: settings)
    }
}

extension AnyFuzzySet: FuzzyStatement {
    public func apply(_ u: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: u)
    }
}

extension IterableFuzzySet: FuzzyStatement {
    public func apply(_ u: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: u)
    }
}

extension DiscreteMutableFuzzySet: FuzzyStatement {
    public func apply(_ u: Universe, settings: OperationSettings) -> Grade {
        grade(forElement: u)
    }
}
