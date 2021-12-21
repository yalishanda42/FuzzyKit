public struct AnyFuzzySet<Universe>: FuzzySet {
    
    internal let membershipFunction: MembershipFunction<Universe>
    
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
        .init { max(membershipFunction($0), alpha) }
    }
    
    public var complement: Self {
        .init { 1 - membershipFunction($0) }
    }
}

public extension AnyFuzzySet {
    static var empty: Self {
        .init(membershipFunction: .zero)
    }
    
    static var universe: Self {
        .init(membershipFunction: .one)
    }
}

public extension DiscreteMutableFuzzySet {
    func eraseToAnyFuzzySet() -> AnyFuzzySet<Universe> {
        .init(membershipFunction: .fromDictionary(grades))
    }
}

public extension IterableFuzzySet {
    func eraseToAnyFuzzySet() -> AnyFuzzySet<Universe> {
        .init(membershipFunction: function)
    }
}
