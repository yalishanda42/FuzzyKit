import FuzzySets

public struct FuzzyConjunction<A: FuzzyProposition, B: FuzzyProposition>: FuzzyProposition {
    
    public let first: A
    public let second: B
    
    public init(_ first: A, _ second: B) {
        self.first = first
        self.second = second
    }
    
    public func apply(_ values: (A.U, B.U), settings: OperationSettings = .init()) -> Grade {
        settings.conjunction.function(
            first(values.0, settings: settings),
            second(values.1, settings: settings)
        )
    }
}


public func && <A: FuzzyProposition, B: FuzzyProposition>(lhs: A, rhs: B) -> FuzzyConjunction<A, B> {
    .init(lhs, rhs)
}
