import FuzzySets

public protocol LinguisticVariable {
    associatedtype TermName
    associatedtype Term: FuzzySet
    func term(_ name: TermName) -> Term?
}

public extension LinguisticVariable {
    /// ! Force-unwraps the term
    subscript(_ termName: TermName) -> Term {
        term(termName)!
    }
    
    /// ! Force-unwraps the term
    func `is`(_ termName: TermName) -> Term {
        term(termName)!
    }
    
    /// ! Force-unwraps the term
    func callAsFunction(`is` termName: TermName) -> Term {
        `is`(termName)
    }
    
    /// ! Force-unwraps the term
    func callAsFunction(_ value: Term.Universe, `is` termName: TermName) -> Grade {
        self(is: termName)(value)
    }
}
