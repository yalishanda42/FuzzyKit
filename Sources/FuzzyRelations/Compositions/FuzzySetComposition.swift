import FuzzySets

public struct FuzzySetComposition<U, V, Seq: Sequence> where Seq.Element == U {
    
    let set: IterableFuzzySet<U, Seq>
    let relation: BinaryFuzzyRelation<U, V>
    
    public init(set: IterableFuzzySet<U, Seq>, relation: BinaryFuzzyRelation<U, V>) {
        self.set = set
        self.relation = relation
    }
}

extension FuzzySetComposition: FuzzySet {
    /// - Complexity: O(*n*) where *n* is the number of elements in `self.set.sequence` (number of elements of `V` to be iterated over via `Seq`)
    public func grade(forElement element: V) -> Grade {
        set.map {
            min($0.grade, relation[$0.element, element])
        }.max() ?? 0
    }
}
