import FuzzySets
import FuzzyRelations

public extension BinaryFuzzyRelation {
    static func implication<P: FuzzySet, Q: FuzzySet>(
        antecedent: P,
        consequent: Q,
        method: ImplicationMethod = .mamdani
    ) -> Self where P.Universe == U, Q.Universe == V {
        .init {
            method.function(antecedent[$0.0], consequent[$0.1])
        }
    }
}
