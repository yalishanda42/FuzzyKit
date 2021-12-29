import FuzzySets
import FuzzyRelations

public extension BinaryFuzzyRelation {
    static func implication<P: FuzzySet, Q: FuzzySet>(
        antecedent: P,
        consequent: Q,
        method: ImplicationMethod = .mamdani
    ) -> Self where P.Universe == U, Q.Universe == V {
        .init {
            (antecedent --> consequent)
                .apply($0.0, $0.1, method: method)
        }
    }
    
    static func implication<P: FuzzySet, Q: FuzzySet>(
        rule: FuzzyRule<P, Q>,
        method: ImplicationMethod = .mamdani
    ) -> Self where P.Universe == U, Q.Universe == V {
        .init {
            rule.apply($0.0, $0.1, method: method)
        }
    }
}
