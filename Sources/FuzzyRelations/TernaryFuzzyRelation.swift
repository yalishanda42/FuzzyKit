import FuzzySets

public class TernaryFuzzyRelation<U, V, W> {
    
    let function: MembershipFunction<(U, V, W)>
    
    public init(_ membershipFunction: MembershipFunction<(U, V, W)>) {
        self.function = membershipFunction
    }
    
    public init(_ membershipFunction: @escaping MembershipFunction<(U, V, W)>.FunctionType) {
        self.function = .init(membershipFunction)
    }
    
    public func grade(forElements elements: (U, V, W)) -> Grade {
        function(elements)
    }
        
    public subscript(_ u: U, _ v: V, _ w: W) -> Grade {
        grade(forElements: (u, v, w))
    }
    
    public subscript(_ x: (U, V, W)) -> Grade {
        grade(forElements: x)
    }
    
    public func asFuzzySet() -> AnyFuzzySet<(U, V, W)> {
        .init(membershipFunction: function)
    }
}
