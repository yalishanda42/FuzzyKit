public struct ContinuousFuzzySet: FuzzySet {
    public typealias Universe = Double
    
    private let membershipFunction: MembershipFunction<Universe>
    
    public init(membershipFunction: MembershipFunction<Universe>) {
        self.membershipFunction = membershipFunction
    }
    
    public init(membershipFunction: @escaping MembershipFunction<Universe>.FunctionType) {
        self.membershipFunction = MembershipFunction(membershipFunction)
    }
    
    public func grade(forElement element: Universe) -> Grade {
        membershipFunction(element)
    }
    
    public func alphaCut(_ alpha: Grade) -> Self {
        .init { min(membershipFunction($0), alpha) }
    }
}

public extension ContinuousFuzzySet {
    static var empty: Self {
        .init(membershipFunction: .zero)
    }
    
    static var universe: Self {
        .init(membershipFunction: .one)
    }
}
