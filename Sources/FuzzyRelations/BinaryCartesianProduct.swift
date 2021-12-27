import FuzzySets

public class BinaryCartesianProduct<A: FuzzySet, B: FuzzySet, U, V>
where A.Universe == U, B.Universe == V {
    
    let first: A
    let second: B
    let function: MembershipFunction<(U, V)>
    
    public init(_ a: A, _ b: B) {
        self.first = a
        self.second = b
        self.function = .init { min(a[$0.0], b[$0.1]) }
    }
    
    public init(_ a: A, _ b: B, membershipFunction: MembershipFunction<(U, V)>) {
        self.first = a
        self.second = b
        self.function = membershipFunction
    }
    
    public init(_ a: A, _ b: B, membershipFunction: @escaping MembershipFunction<(U, V)>.FunctionType) {
        self.first = a
        self.second = b
        self.function = .init(membershipFunction)
    }
    
    public func grade(forElements elements: (U, V)) -> Grade {
        function(elements)
    }
        
    public subscript(_ u: U, _ v: V) -> Grade {
        grade(forElements: (u, v))
    }
    
    public func asFuzzySet() -> AnyFuzzySet<(U, V)> {
        .init(membershipFunction: function)
    }
}
