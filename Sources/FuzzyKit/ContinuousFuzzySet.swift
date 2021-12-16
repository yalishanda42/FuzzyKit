public struct ContinuousFuzzySet: FuzzySet {
    public typealias Element = Double
    
    private let membershipFunction: MembershipFunction
    
    public init(membershipFunction: MembershipFunction) {
        self.membershipFunction = membershipFunction
    }
    
    public init(membershipFunction: @escaping (Element) -> Grade) {
        self.membershipFunction = MembershipFunction(membershipFunction)
    }
    
    public func grade(forElement element: Element) -> Grade {
        membershipFunction(element)
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
