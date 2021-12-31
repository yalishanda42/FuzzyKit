import FuzzySets

open class ModifiableLinguisticVariable<TermName: Hashable, Term: FuzzySetOperations, TermModifierName: Hashable>: LinguisticVariable<TermName, Term> {
    
    public typealias TermModifier = (Grade) -> Grade
    
    let termModifiers: [TermModifierName: TermModifier]
    
    public init(
        baseTerms: [TermName: Term],
        termModifiers: [TermModifierName: TermModifier] = [:]
    ) {
        self.termModifiers = termModifiers
        super.init(baseTerms)
    }
    
    open subscript(_ termName: TermName, applyModifier modifierName: TermModifierName) -> Term? {
        applyModifier(modifierName, to: termName)
    }
    
    open func applyModifier(_ modifierName: TermModifierName, to termName: TermName) -> Term? {
        guard let term = term(termName) else { return nil }
        return applyModifier(modifierName, to: term)
    }
    
    open func applyModifier(_ modifierName: TermModifierName, to term: Term) -> Term? {
        guard let modifier = termModifiers[modifierName] else { return nil }
        return term.appliedCustomFunction(modifier)
    }
}
