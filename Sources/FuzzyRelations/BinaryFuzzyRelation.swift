import FuzzySets

public class BinaryFuzzyRelation<U, V> {
    
    let function: MembershipFunction<(U, V)>
    
    public init(_ membershipFunction: MembershipFunction<(U, V)>) {
        self.function = membershipFunction
    }
    
    public init(_ membershipFunction: @escaping MembershipFunction<(U, V)>.FunctionType) {
        self.function = .init(membershipFunction)
    }
}

extension BinaryFuzzyRelation: FuzzySet {
    public func grade(forElement elements: (U, V)) -> Grade {
        function(elements)
    }
        
    public subscript(_ u: U, _ v: V) -> Grade {
        grade(forElement: (u, v))
    }
}

extension BinaryFuzzyRelation: AnyFuzzySetRepresentable {
    public func eraseToAnyFuzzySet() -> AnyFuzzySet<(U, V)> {
        .init(membershipFunction: function)
    }
}
