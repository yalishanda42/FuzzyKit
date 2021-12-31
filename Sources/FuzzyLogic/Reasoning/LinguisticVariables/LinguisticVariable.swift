import FuzzySets

open class LinguisticVariable<TermName: Hashable, Term: FuzzySet> {

    let terms: [TermName: Term]
    
    public init(_ terms: [TermName: Term]) {
        self.terms = terms
    }
    
    open func term(_ name: TermName) -> Term? {
        terms[name]
    }
    
    /// ! Force-unwraps the term
    open subscript(_ termName: TermName) -> Term {
        term(termName)!
    }
    
    /// ! Force-unwraps the term
    open func `is`(_ termName: TermName) -> Term {
        term(termName)!
    }
    
    /// ! Force-unwraps the term
    open func callAsFunction(`is` termName: TermName) -> Term {
        `is`(termName)
    }
    
    /// ! Force-unwraps the term
    open func callAsFunction(_ value: Term.Universe, `is` termName: TermName) -> Grade {
        self(is: termName)(value)
    }
}
