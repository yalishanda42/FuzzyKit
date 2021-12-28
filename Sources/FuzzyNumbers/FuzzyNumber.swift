import FuzzySets

public protocol FuzzyNumber: FuzzySet where Universe == Double {
    
    static func + (lhs: Self, rhs: Self) -> Self
    
    static func - (lhs: Self, rhs: Self) -> Self
    
    prefix static func - (x: Self) -> Self
    
//    func approximatelyMultiplied(by other: Self) -> Self
//
//    func approximatelyDivided(by other: Self) -> Self
}
