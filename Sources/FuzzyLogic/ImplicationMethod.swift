import FuzzySets

/// Describes a function used for forming a fuzzy implication.
///
/// A function `I` must satisfy the following axioms in order to be called a fuzzy implication:
/// 1. Boundary condition: `S(1, 1) = 1`, `S(1, 0) = 0`, `S(0, 0) = 1`
/// 2. Non-increasing `y`: `If x_1 <= x_2 Then I(x_1, y) >= I(x_2, y)`
/// 3. Non-decreasing `x`: `If y_1 <= y_2 Then I(x, y_1) <= I(x, y_2)`
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
