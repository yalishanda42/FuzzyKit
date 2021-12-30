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
