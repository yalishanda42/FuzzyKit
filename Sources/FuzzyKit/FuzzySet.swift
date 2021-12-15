/// Grade membership of an element. Should always be a real number in the interval `[0, 1]`.
public typealias Grade = Double

public protocol FuzzySet {
    associatedtype Element
    
    func grade(forElement element: Element) -> Grade
        
    subscript(_ element: Element) -> Grade { get }
}

public extension FuzzySet {
    subscript(_ element: Element) -> Grade {
        get {
            grade(forElement: element)
        }
    }
}

