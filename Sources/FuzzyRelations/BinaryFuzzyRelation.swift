import FuzzySets

public class BinaryFuzzyRelation<U, V> {
    
    let function: MembershipFunction<(U, V)>
    
    public init(_ membershipFunction: MembershipFunction<(U, V)>) {
        self.function = membershipFunction
    }
    
    public init(_ membershipFunction: @escaping MembershipFunction<(U, V)>.FunctionType) {
        self.function = .init(membershipFunction)
    }
    
    public func grade(forElements elements: (U, V)) -> Grade {
        function(elements)
    }
        
    public subscript(_ u: U, _ v: V) -> Grade {
        grade(forElements: (u, v))
    }
        
    public subscript(_ x: (U, V)) -> Grade {
        grade(forElements: x)
    }
    
    public func asFuzzySet() -> AnyFuzzySet<(U, V)> {
        .init(membershipFunction: function)
    }
}
