import FuzzySets

public struct FuzzyRule<P: FuzzyProposition, Q: FuzzyProposition>: FuzzyProposition {
    public let antecedent: P
    public let consequent: Q
    
    public init(antecedent: P, consequent: Q) {
        self.antecedent = antecedent
        self.consequent = consequent
    }
    
    public func apply(_ values: (P.U, Q.U), settings: OperationSettings = .init()) -> Grade {
        settings.implication.function(
            antecedent(values.0, settings: settings),
            consequent(values.1, settings: settings)
        )
    }
}

infix operator -->: TernaryPrecedence  // lower than ==, &&, ||, etc
public func --> <P: FuzzyProposition, Q: FuzzyProposition> (lhs: P, rhs: Q) -> FuzzyRule<P, Q> {
    .init(antecedent: lhs, consequent: rhs)
}
