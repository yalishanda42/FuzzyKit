import FuzzySets
import FuzzyRelations

public struct GeneralizedModusPonens<U, V, Seq: Sequence> where Seq.Element == U {
    
    let composition: FuzzySetComposition<U, V, Seq>
    
    public init<P: FuzzySet, Q: FuzzySet>(
        ruleAntecedent: P,
        ruleConsequent: Q,
        fact: IterableFuzzySet<U, Seq>,
        method: ImplicationMethod = .mamdani
    ) where P.Universe == U, Q.Universe == V {
        self.composition = .init(
            set: fact,
            relation: .implication(
                antecedent: ruleAntecedent,
                consequent: ruleConsequent,
                method: method
            )
        )
    }
}

extension GeneralizedModusPonens: FuzzySet {
    public func grade(forElement element: V) -> Grade {
        composition[element]
    }
}

extension GeneralizedModusPonens: AnyFuzzySetRepresentable {
    public func eraseToAnyFuzzySet() -> AnyFuzzySet<V> {
        .init { composition[$0] }
    }
}
