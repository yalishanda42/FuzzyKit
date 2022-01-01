import FuzzySets

public struct OperationSettings {
    public var negation: ComplementFunction
    public var implication: ImplicationMethod
    public var conjunction: TNormFunction
    public var disjunction: SNormFunction
    public var xor: SymmetricDifferenceFunction
    
    public init(
        negation: ComplementFunction = .standard,
        implication: ImplicationMethod = .mamdani,
        conjunction: TNormFunction = .minimum,
        disjunction: SNormFunction = .maximum,
        xor: SymmetricDifferenceFunction = .absoluteValue
    ) {
        self.negation = negation
        self.implication = implication
        self.conjunction = conjunction
        self.disjunction = disjunction
        self.xor = xor
    }
}
