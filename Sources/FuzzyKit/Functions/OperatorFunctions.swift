public enum TNormFunction {
    case minimum
    case lukasiewicz
    case product
    case weak
    case hamacher
    case duboisAndPrade
    case yager
    case frank
    case custom((Grade, Grade) -> Grade)
    
    var function: (Grade, Grade) -> Grade {
        min
        // TODO
    }
}

public enum SNormFunction {
    case maximum
    case lukasiewicz
    case probabilistic
    case strong
    case hamacher
    case yager
    case custom((Grade, Grade) -> Grade)
    
    var function: (Grade, Grade) -> Grade {
        max
        // TODO
    }
}

public enum ComplementFunction {
    case standard
    case yager
    case sugeno
    case custom((Grade) -> Grade)
    
    var function: (Grade) -> Grade {
        { 1 - $0 }
        // TODO
    }
}

public enum DifferenceFunction {
    /// `µC = t(µA(x), c(µB(x))), C = A\B`
    case tNormAndComplement(TNormFunction, ComplementFunction)
    /// `µC = µA - t(µA(x), µB(x)), C = A\B`
    case differenceAndTNorm(TNormFunction)
    
    case custom((Grade, Grade) -> Grade)
    
    var function: (Grade, Grade) -> Grade {
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
    
    var function: (Grade, Grade) -> Grade {
        switch self {
        case .absoluteValue:
            return { abs($0 - $1) }
        case .minMaxAndStandardComplement:
            return { max(min($0, 1 - $1), min($1, 1 - $0)) }
        case .tNormSNormAndComplement(let t, let s, let c):
            return { s.function(t.function($0, c.function($1)), t.function($1, c.function($0))) }
        case .custom(let function):
            return function
        }
    }
}
