public protocol FuzzySetOperations: FuzzySet {
    
    func alphaCut(_ alpha: Grade) -> Self
    
    func complement(method: ComplementFunction) -> Self
    
    func intersection(_ other: Self, method: TNormFunction) -> Self
    
    func union(_ other: Self, method: SNormFunction) -> Self
    
    func difference(_ other: Self, method: DifferenceFunction) -> Self
    
    func symmetricDifference(_ other: Self, method: SymmetricDifferenceFunction) -> Self
    
    func power(_ n: Double) -> Self
    
    func appliedCustomFunction(_ function: @escaping (Grade) -> Grade) -> Self
}
