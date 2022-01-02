import FuzzySets

public struct SimpleLinguisticVariable<TermName: Hashable, Term: FuzzySet>: LinguisticVariable, ExpressibleByDictionaryLiteral {

    let terms: [TermName: Term]
    
    public init(_ terms: [TermName: Term]) {
        self.terms = terms
    }
    
    public init(dictionaryLiteral elements: (TermName, Term)...) {
        self.terms = .init(uniqueKeysWithValues: elements)
    }
    
    public func term(_ name: TermName) -> Term? {
        terms[name]
    }
}
