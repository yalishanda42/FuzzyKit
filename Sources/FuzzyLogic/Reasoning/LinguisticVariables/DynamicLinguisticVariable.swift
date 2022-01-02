import FuzzySets

public struct DynamicLinguisticVariable<TermName, Term: FuzzySet>: LinguisticVariable {
    
    let generator: (TermName) -> Term?
    
    public init(_ termGeneratorFunction: @escaping (TermName) -> Term?) {
        self.generator = termGeneratorFunction
    }
    
    public func term(_ name: TermName) -> Term? {
        generator(name)
    }
}
