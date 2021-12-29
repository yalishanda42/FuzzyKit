import FuzzySets

public enum CompositionMethod {
    case maxmin
    case minmax
    case maxprod
}

public struct FuzzyRelationsComposition<U, V, W, Seq: Sequence> where Seq.Element == V {
    
    let relationUV: BinaryFuzzyRelation<U, V>
    let relationVW: BinaryFuzzyRelation<V, W>
    let sequence: Seq
    let method: CompositionMethod
    
    public init(
        _ relationUV: BinaryFuzzyRelation<U, V>,
        _ relationVW: BinaryFuzzyRelation<V, W>,
        sequence: Seq,
        method: CompositionMethod = .maxmin
    ) {
        self.relationUV = relationUV
        self.relationVW = relationVW
        self.sequence = sequence
        self.method = method
    }
}

public extension FuzzyRelationsComposition where V: CaseIterable, Seq == V.AllCases {
    init(
        _ relationUV: BinaryFuzzyRelation<U, V>,
        _ relationVW: BinaryFuzzyRelation<V, W>,
        method: CompositionMethod = .maxmin
    ) {
        self.relationUV = relationUV
        self.relationVW = relationVW
        self.sequence = V.allCases
        self.method = method
    }
}

extension FuzzyRelationsComposition: FuzzySet {
    /// - Complexity: O(*n*) where *n* is the number of elements in `self.sequence` (number of elements of `V` to be iterated over via `Seq`)
    public func grade(forElement element: (U, W)) -> Grade {
        let u = element.0
        let w = element.1
        switch method {
        case .maxmin:
            return sequence.map {
                min(relationUV[u, $0], relationVW[$0, w])
            }.max() ?? 0
        case .minmax:
            return sequence.map {
                max(relationUV[u, $0], relationVW[$0, w])
            }.min() ?? 0
        case .maxprod:
            return sequence.map {
                relationUV[u, $0] * relationVW[$0, w]
            }.max() ?? 0
        }
    }
    
    public subscript(_ u: U, _ w: W) -> Grade {
        grade(forElement: (u, w))
    }
}
