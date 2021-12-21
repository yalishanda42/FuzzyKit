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
