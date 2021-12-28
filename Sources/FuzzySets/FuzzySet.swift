/// Grade membership of an element. Should always be a real number in the interval `[0, 1]`.
public typealias Grade = Double

public protocol FuzzySet {
    associatedtype Universe
    
    func grade(forElement element: Universe) -> Grade
        
    subscript(_ element: Universe) -> Grade { get }
}

public extension FuzzySet {
    subscript(_ element: Universe) -> Grade {
        get {
            grade(forElement: element)
        }
    }
}
