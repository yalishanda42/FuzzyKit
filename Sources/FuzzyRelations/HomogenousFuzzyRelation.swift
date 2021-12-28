import FuzzySets

class HomogenousFuzzyRelation<U> {
    
    let function: MembershipFunction<[U]>
    
    public init(_ membershipFunction: MembershipFunction<[U]>) {
        self.function = membershipFunction
    }
    
    public init(_ membershipFunction: @escaping MembershipFunction<[U]>.FunctionType) {
        self.function = .init(membershipFunction)
    }
}

extension HomogenousFuzzyRelation: FuzzySet {
    public func grade(forElement element: [U]) -> Grade {
        function(element)
    }
        
    public subscript(_ u: U...) -> Grade {
        grade(forElement: u)
    }
}

extension HomogenousFuzzyRelation: AnyFuzzySetRepresentable {
    public func eraseToAnyFuzzySet() -> AnyFuzzySet<[U]> {
        .init(membershipFunction: function)
    }
}
