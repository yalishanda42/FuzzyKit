import FuzzySets
import FuzzyRelations

public extension BinaryFuzzyRelation {
    static func implication<P: FuzzySet, Q: FuzzySet>(
        antecedent: P,
        consequent: Q,
        method: ImplicationMethod = .mamdani
    ) -> Self where P.Universe == U, Q.Universe == V {
        .init {
            method.function(antecedent($0.0), consequent($0.1))
        }
    }
}

public extension FuzzyRule {
    func asRelation<P, Q>() -> BinaryFuzzyRelation<P, Q> where Input == (P, Q) {
        .init { (p, q) in self((p, q)) }
    }
}
