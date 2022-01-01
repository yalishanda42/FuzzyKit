import FuzzySets

public struct FuzzyRule<Input>: FuzzyProposition {
    
    private let function: (Input, OperationSettings) -> Grade
    
    public init<P: FuzzyProposition, Q: FuzzyProposition>(antecedent: P, consequent: Q) where Input == (P.Input, Q.Input) {
        self.function = { (x, settings) -> Grade in
            settings.implication.function(
                antecedent(x.0, settings: settings),
                consequent(x.1, settings: settings)
            )
        }
    }
    
    public func apply(_ values: Input, settings: OperationSettings = .init()) -> Grade {
        function(values, settings)
    }
}

infix operator -->: TernaryPrecedence  // lower than ==, &&, ||, etc
public func --> <P: FuzzyProposition, Q: FuzzyProposition> (lhs: P, rhs: Q) -> FuzzyRule<(P.Input, Q.Input)> {
    .init(antecedent: lhs, consequent: rhs)
}
