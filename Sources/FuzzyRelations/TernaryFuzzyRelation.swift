import FuzzySets

public struct TernaryFuzzyRelation<U, V, W> {
    
    let function: MembershipFunction<(U, V, W)>
    
    public init(_ membershipFunction: MembershipFunction<(U, V, W)>) {
        self.function = membershipFunction
    }
    
    public init(_ membershipFunction: @escaping MembershipFunction<(U, V, W)>.FunctionType) {
        self.function = .init(membershipFunction)
    }
}

extension TernaryFuzzyRelation: FuzzySet {
    public func grade(forElement element: (U, V, W)) -> Grade {
        function(element)
    }
        
    public subscript(_ u: U, _ v: V, _ w: W) -> Grade {
        grade(forElement: (u, v, w))
    }
        
    public func callAsFunction(_ u: U, _ v: V, _ w: W) -> Grade {
        grade(forElement: (u, v, w))
    }
}
 
extension TernaryFuzzyRelation: AnyFuzzySetRepresentable {
    public func eraseToAnyFuzzySet() -> AnyFuzzySet<(U, V, W)> {
        .init(membershipFunction: function)
    }
}
