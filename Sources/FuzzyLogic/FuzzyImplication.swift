import FuzzySets

public enum ImplicationMethod {
    case larsen
    case lukasiewicz
    case mamdani
    case standardStrict
    case goedel
    case gaines
    case kleeneDienes
    case kleeneDienesLuk
    
    case custom((Grade, Grade) -> Grade)
    
    var function: (Grade, Grade) -> Grade {
        switch self {
        case .larsen:
            return { $0 * $1 }
        case .lukasiewicz:
            return { min(1, 1 - $0 + $1) }
        case .mamdani:
            return min
        case .standardStrict:
            return { $0 <= $1 ? 1 : 0 }
        case .goedel:
            return { $0 <= $1 ? 1 : $1 }
        case .gaines:
            return { $0 <= $1 ? 1 : $1/$0 }
        case .kleeneDienes:
            return { max(1 - $0, $1) }
        case .kleeneDienesLuk:
            return { 1 - $0 + $0*$1 }
        case .custom(let function):
            return function
        }
    }
}

public extension AnyFuzzySet {
    func implication(_ other: Self, method: ImplicationMethod = .mamdani) -> Self {
        .init {
            method.function(self[$0], other[$0])
        }
    }
}

public extension IterableFuzzySet {
    func implication(_ other: Self, method: ImplicationMethod = .mamdani) -> Self {
        .init(sequence) {
            method.function(self[$0], other[$0])
        }
    }
}

public extension DiscreteMutableFuzzySet {
    func implication(_ other: Self, method: ImplicationMethod = .mamdani) -> Self {
        var result = self
        result.formImplication(other, method: method)
        return result
    }
    
    mutating func formImplication(_ other: Self, method: ImplicationMethod = .mamdani) {
        applyFunction(method.function, whenMergingWith: other)
    }
}
