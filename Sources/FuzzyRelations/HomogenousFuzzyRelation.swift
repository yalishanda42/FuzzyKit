import FuzzySets

class HomogenousFuzzyRelation<U> {
    
    let function: MembershipFunction<[U]>
    
    public init(_ membershipFunction: MembershipFunction<[U]>) {
        self.function = membershipFunction
    }
    
    public init(_ membershipFunction: @escaping MembershipFunction<[U]>.FunctionType) {
        self.function = .init(membershipFunction)
    }
    
    public func grade(forElements elements: [U]) -> Grade {
        function(elements)
    }
        
    public subscript(_ u: U...) -> Grade {
        grade(forElements: u)
    }
        
    public subscript(_ u: [U]) -> Grade {
        grade(forElements: u)
    }
    
    public func asFuzzySet() -> AnyFuzzySet<[U]> {
        .init(membershipFunction: function)
    }
}
