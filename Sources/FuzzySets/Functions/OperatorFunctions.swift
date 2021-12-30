import RealModule
/// Describes a T-norm function, usually used for forming an intersection of fuzzy sets.
///
/// A function `T` must satisfy the following axioms in order to be T-normed:
/// 1. Boundary condition: `T(1, 1) = 1`, `T(1, 0) = 0`, `T(0, 1) = 0`, `T(0, 0) = 0`
/// 2. Commutativity: `T(a, b) = T(b, a)`
/// 3. Monotonic: `If a <= a' and b <= b' Then T(a, b) <= T(a', b')`
/// 4. Associativity: `T(T(a, b), c) = T(a, T(b, c))`
public enum TNormFunction {
    case minimum
    case lukasiewicz
    case product
    case weak
    case hamacher(gamma: Double)
    case duboisAndPrade(alpha: Double)
    case yager(p: Double)
    case frank(lambda: Double)
    
    case custom((Grade, Grade) -> Grade)
    
    public var function: (Grade, Grade) -> Grade {
        switch self {
        case .minimum:
            return min
        case .lukasiewicz:
            return { max($0 + $1, 1) }
        case .product:
            return { $0 * $1 }
        case .weak:
            return { max($0, $1) == 1 ? min($0, $1) : 0 }
        case .hamacher(gamma: let g):
            return { $0 * $1 / (g + (1 - g)*($0 + $1 - $0*$1)) }
        case .duboisAndPrade(alpha: let a):
            return { $0 * $1 / max($0, $1, a) }
        case .yager(p: let p):
            return {
                1 - min(1.0, ((1-$0).pow(p) + (1-$1).pow(p)).root(p))
            }
        case .frank(lambda: let l):
            switch l {
            case 0:
                return TNormFunction.minimum.function
            case 1:
                return TNormFunction.product.function
            case .infinity:
                return TNormFunction.lukasiewicz.function
            default:
                return {
                    1 - (1 + (l.pow($0) - 1)*(l.pow($1) - 1) / (l - 1)).log(base: l)
                }
            }
        case .custom(let function):
            return function
        }
    }
}

/// Describes a S-norm (T-conorm) function, usually used for forming a union of fuzzy sets.
///
/// A function `S` must satisfy the following axioms in order to be S-normed (T-conormed):
/// 1. Boundary condition: `S(1, 1) = 1`, `S(1, 0) = 1`, `S(0, 1) = 1`, `S(0, 0) = 0`
/// 2. Commutativity: `S(a, b) = S(b, a)`
/// 3. Monotonic: `If a <= a' and b <= b' Then S(a, b) <= S(a', b')`
/// 4. Associativity: `S(T(a, b), c) = S(a, T(b, c))`
public enum SNormFunction {
    case maximum
    case lukasiewicz
    case probabilistic
    case strong
    case hamacher(gamma: Double)
    case yager(p: Double)
    
    case custom((Grade, Grade) -> Grade)
    
    public var function: (Grade, Grade) -> Grade {
        switch self {
        case .maximum:
            return max
        case .lukasiewicz:
            return { min($0 + $1, 1) }
        case .probabilistic:
            return { $0 + $1 - $0*$1 }
        case .strong:
            return { min($0, $1) == 0 ? max($0, $1) : 1 }
        case .hamacher(gamma: let g):
            return { ($0 + $1 - (2 - g)*$0*$1) / (1 - (1 - g)*$0*$1) }
        case .yager(p: let p):
            return { min(1, ($0.pow(p) + $1.pow(p)).root(p)) }
        case .custom(let function):
            return function
        }
    }
}

/// Describes a complement (negation) function, usually used for forming a complement (negation) of a fuzzy set.
///
/// A function `c` must satisfy the following axioms in order to be capable of negating a fuzzy set:
/// 1. Boundary condition: `c(0) = 1`, `c(1) = 0`
/// 2. Monotonic nonincreasing: `a < b -> c(a) >= c(b)`
/// 3. Involution: `c(c(a)) = a`
public enum ComplementFunction {
    case standard
    case yager(w: Double)
    case sugeno(s: Double)
    
    case custom((Grade) -> Grade)
    
    public var function: (Grade) -> Grade {
        switch self {
        case .standard:
            return { 1 - $0 }
        case .yager(w: let w):
            return { (1 - $0.pow(w)).root(w) }
        case .sugeno(s: let s):
            return { (1 - $0) / (1 - s * $0) }
        case .custom(let function):
            return function
        }
    }
}

public enum DifferenceFunction {
    /// `µC = t(µA(x), c(µB(x))), C = A\B`
    case tNormAndComplement(TNormFunction, ComplementFunction)
    /// `µC = µA - t(µA(x), µB(x)), C = A\B`
    case differenceAndTNorm(TNormFunction)
    
    case custom((Grade, Grade) -> Grade)
    
    public var function: (Grade, Grade) -> Grade {
        switch self {
        case .tNormAndComplement(let t, let c):
            return { t.function($0, c.function($1)) }
        case .differenceAndTNorm(let t):
            return { $0 - t.function($0, $1) }
        case .custom(let function):
            return function
        }
    }
}

public enum SymmetricDifferenceFunction {
    case absoluteValue
    case minMaxAndStandardComplement
    case tNormSNormAndComplement(TNormFunction, SNormFunction, ComplementFunction)
    case custom((Grade, Grade) -> Grade)
    
    public var function: (Grade, Grade) -> Grade {
        switch self {
        case .absoluteValue:
            return { abs($0 - $1) }
        case .minMaxAndStandardComplement:
            return { max(min($0, 1 - $1), min($1, 1 - $0)) }
        case .tNormSNormAndComplement(let t, let s, let c):
            return {
                s.function(
                    t.function($0, c.function($1)),
                    t.function($1, c.function($0))
                )
            }
        case .custom(let function):
            return function
        }
    }
}

internal extension Double {
    func pow(_ x: Double) -> Double {
        Double.pow(self, x)
    }
    
    func pow(_ n: Int) -> Double {
        Double.pow(self, n)
    }
    
    func log(base: Double) -> Double {
        Double.log(self) / Double.log(base)
    }
    
    func root(_ x: Double) -> Double {
        Double.pow(self, 1/x)
    }
}
