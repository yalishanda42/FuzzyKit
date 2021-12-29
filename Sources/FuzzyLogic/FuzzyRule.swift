import FuzzySets

public struct FuzzyRule<P: FuzzySet, Q: FuzzySet> {
    public let antecedent: P
    public let consequent: Q
    
    public init(antecedent: P, consequent: Q) {
        self.antecedent = antecedent
        self.consequent = consequent
    }
    
    public func apply(
        _ p: P.Universe,
        _ q: Q.Universe,
        method: ImplicationMethod = .mamdani
    ) -> Grade {
        method.function(antecedent[p], consequent[q])
    }
}

infix operator -->: TernaryPrecedence  // lower than ==, &&, ||, etc
public func --> <P: FuzzySet, Q: FuzzySet> (lhs: P, rhs: Q) -> FuzzyRule<P, Q> {
    .init(antecedent: lhs, consequent: rhs)
}
