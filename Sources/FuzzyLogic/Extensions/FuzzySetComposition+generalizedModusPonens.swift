import FuzzySets
import FuzzyRelations

public extension FuzzySetComposition {
    static func generalizedModusPonens<P: FuzzySet, Q: FuzzySet>(
        antecedent: P,
        consequent: Q,
        fact: IterableFuzzySet<U, Seq>,
        method: ImplicationMethod = .mamdani
    ) -> Self where P.Universe == U, Q.Universe == V {
         .init(
            set: fact,
            relation: .implication(
                antecedent: antecedent,
                consequent: consequent,
                method: method
            )
        )
    }
}
