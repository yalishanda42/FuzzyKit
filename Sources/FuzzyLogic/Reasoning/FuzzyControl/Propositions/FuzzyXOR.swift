import FuzzySets

public struct FuzzyXOR<Input>: FuzzyProposition {
    
    private let function: (Input, OperationSettings) -> Grade
    
    public init<P: FuzzyProposition, Q: FuzzyProposition>(lhs: P, rhs: Q) where Input == (P.Input, Q.Input) {
        self.function = { (x, settings) -> Grade in
            settings.xor.function(
                lhs(x.0, settings: settings),
                rhs(x.1, settings: settings)
            )
        }
    }
    
    public func apply(_ values: Input, settings: OperationSettings = .init()) -> Grade {
        function(values, settings)
    }
}

infix operator ^^: ComparisonPrecedence
public func ^^ <P: FuzzyProposition, Q: FuzzyProposition> (lhs: P, rhs: Q) -> FuzzyXOR<(P.Input, Q.Input)> {
    .init(lhs: lhs, rhs: rhs)
}
