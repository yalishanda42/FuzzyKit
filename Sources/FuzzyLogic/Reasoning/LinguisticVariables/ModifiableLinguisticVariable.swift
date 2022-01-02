import FuzzySets

public struct ModifiableLinguisticVariable<TermName: Hashable, Term: FuzzySetOperations, TermModifierName: Hashable>: LinguisticVariable {
    
    public typealias TermModifier = (Grade) -> Grade
    
    let terms: [TermName: Term]
    let termModifiers: [TermModifierName: TermModifier]
    
    public init(
        baseTerms: [TermName: Term],
        termModifiers: [TermModifierName: TermModifier] = [:]
    ) {
        self.terms = baseTerms
        self.termModifiers = termModifiers
    }
    
    public func term(_ name: TermName) -> Term? {
        terms[name]
    }
    
    public subscript(_ termName: TermName, applyModifier modifierName: TermModifierName) -> Term? {
        applyModifier(modifierName, to: termName)
    }
    
    public func applyModifier(_ modifierName: TermModifierName, to termName: TermName) -> Term? {
        guard let term = term(termName) else { return nil }
        return applyModifier(modifierName, to: term)
    }
    
    public func applyModifier(_ modifierName: TermModifierName, to term: Term) -> Term? {
        guard let modifier = termModifiers[modifierName] else { return nil }
        return term.appliedCustomFunction(modifier)
    }
}
