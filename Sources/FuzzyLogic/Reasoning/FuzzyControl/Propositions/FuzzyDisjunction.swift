import FuzzySets

public struct FuzzyDisjunction<Input>: FuzzyProposition {
    
    private let function: (Input, OperationSettings) -> Grade
    
    public init<P: FuzzyProposition, Q: FuzzyProposition>(lhs: P, rhs: Q) where Input == (P.Input, Q.Input) {
        self.function = { (x, settings) -> Grade in
            settings.disjunction.function(
                lhs(x.0, settings: settings),
                rhs(x.1, settings: settings)
            )
        }
    }
    
    public func apply(_ values: Input, settings: OperationSettings = .init()) -> Grade {
        function(values, settings)
    }
}

public func || <P: FuzzyProposition, Q: FuzzyProposition> (lhs: P, rhs: Q) -> FuzzyDisjunction<(P.Input, Q.Input)> {
    .init(lhs: lhs, rhs: rhs)
}
