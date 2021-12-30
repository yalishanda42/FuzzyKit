import FuzzySets
import FuzzyRelations

public extension FuzzySetComposition {
    static func generalizedModusPonens<P: FuzzySet, Q: FuzzySet>(
        premiseAntecedent: P,
        premiseConsequent: Q,
        fact: IterableFuzzySet<U, Seq>,
        method: ImplicationMethod = .mamdani
    ) -> Self where P.Universe == U, Q.Universe == V {
         .init(
            set: fact,
            relation: .implication(
                antecedent: premiseAntecedent,
                consequent: premiseConsequent,
                method: method
            )
        )
    }
}
