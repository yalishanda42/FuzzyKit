import FuzzySets

public struct FuzzyXOR<A: FuzzyProposition, B: FuzzyProposition>: FuzzyProposition {
    
    public let first: A
    public let second: B
    
    public init(_ first: A, _ second: B) {
        self.first = first
        self.second = second
    }
    
    public func apply(_ values: (A.U, B.U), settings: OperationSettings = .init()) -> Grade {
        settings.xor.function(
            first(values.0, settings: settings),
            second(values.1, settings: settings)
        )
    }
}

infix operator ^^: ComparisonPrecedence
public func ^^ <A: FuzzyProposition, B: FuzzyProposition>(lhs: A, rhs: B) -> FuzzyXOR<A, B> {
    .init(lhs, rhs)
}
