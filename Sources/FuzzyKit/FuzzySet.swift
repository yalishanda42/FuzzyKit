/// Grade membership of an element. Should always be a real number in the interval `[0, 1]`.
public typealias Grade = Double

public protocol FuzzySet {
    associatedtype Universe
    
    func grade(forElement element: Universe) -> Grade
        
    subscript(_ element: Universe) -> Grade { get }
    
    func alphaCut(_ alpha: Grade) -> Self
    
    func complement(method: ComplementFunction) -> Self
    
    func intersection(_ other: Self, method: TNormFunction) -> Self
    
    func union(_ other: Self, method: SNormFunction) -> Self
    
    func difference(_ other: Self, method: DifferenceFunction) -> Self
    
    func symmetricDifference(_ other: Self, method: SymmetricDifferenceFunction) -> Self
    
    func power(_ n: Double) -> Self
}

public extension FuzzySet {
    subscript(_ element: Universe) -> Grade {
        get {
            grade(forElement: element)
        }
    }
}
