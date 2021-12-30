import FuzzySets

public protocol FuzzyImplicationCapable: FuzzySet {
    func implication(_ other: Self, method: ImplicationMethod) -> Self
}

extension AnyFuzzySet: FuzzyImplicationCapable {
    public func implication(_ other: Self, method: ImplicationMethod = .mamdani) -> Self {
        .init {
            method.function(self[$0], other[$0])
        }
    }
}

extension IterableFuzzySet: FuzzyImplicationCapable {
    public func implication(_ other: Self, method: ImplicationMethod = .mamdani) -> Self {
        .init(sequence) {
            method.function(self[$0], other[$0])
        }
    }
}

extension DiscreteMutableFuzzySet: FuzzyImplicationCapable {
    public func implication(_ other: Self, method: ImplicationMethod = .mamdani) -> Self {
        var result = self
        result.formImplication(other, method: method)
        return result
    }
    
    mutating func formImplication(_ other: Self, method: ImplicationMethod = .mamdani) {
        applyFunction(method.function, whenMergingWith: other)
    }
}
