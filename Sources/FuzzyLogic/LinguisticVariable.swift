import FuzzySets

public struct LinguisticVariable<Universe, TermName: Hashable, Term: FuzzySetOperations, TermModifierName: Hashable> {
    
    public typealias TermModifier = (Grade) -> Grade
    
    let baseTerms: [TermName: Term]
    let termModifiers: [TermModifierName: TermModifier]
    
    public init(
        baseTerms: [TermName: Term],
        termModifiers: [TermModifierName: TermModifier] = [:]
    ) {
        self.baseTerms = baseTerms
        self.termModifiers = termModifiers
    }
    
    public func term(_ name: TermName) -> Term? {
        baseTerms[name]
    }
    
    public subscript(_ termName: TermName) -> Term? {
        term(termName)
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
