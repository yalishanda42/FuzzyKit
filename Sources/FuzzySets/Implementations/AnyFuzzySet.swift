import RealModule

public struct AnyFuzzySet<Universe> {
    internal let membershipFunction: MembershipFunction<Universe>
    
    public init(membershipFunction: MembershipFunction<Universe>) {
        self.membershipFunction = membershipFunction
    }
    
    public init(membershipFunction: @escaping MembershipFunction<Universe>.FunctionType) {
        self.membershipFunction = MembershipFunction(membershipFunction)
    }
}

// MARK: - Fuzzy set

extension AnyFuzzySet: FuzzySet {
    public func grade(forElement element: Universe) -> Grade {
        membershipFunction(element)
    }
}

// MARK: - Fuzzy set operations

extension AnyFuzzySet: FuzzySetOperations {
    public func alphaCut(_ alpha: Grade) -> Self {
        .init { max(membershipFunction($0), alpha) }
    }
    
    public func complement(method: ComplementFunction = .standard) -> Self {
        .init { method.function(membershipFunction($0)) }
    }
    
    public func intersection(_ other: Self, method: TNormFunction = .minimum) -> Self {
        .init { method.function(membershipFunction($0), other.membershipFunction($0)) }
    }
    
    public func union(_ other: Self, method: SNormFunction = .maximum) -> Self {
        .init { method.function(membershipFunction($0), other.membershipFunction($0)) }
    }
    
    public func difference(_ other: Self, method: DifferenceFunction = .tNormAndComplement(.minimum, .standard)) -> Self {
        .init { method.function(membershipFunction($0), other.membershipFunction($0)) }
    }
    
    public func symmetricDifference(_ other: Self, method: SymmetricDifferenceFunction = .absoluteValue) -> Self {
        .init { method.function(membershipFunction($0), other.membershipFunction($0)) }
    }
    
    public func power(_ n: Double) -> Self {
        .init { Double.pow(membershipFunction($0), n) }
    }
    
    public func appliedCustomFunction(_ function: @escaping (Grade) -> Grade) -> Self {
        .init { function(membershipFunction($0)) }
    }
}

// MARK: - Common sets

public extension AnyFuzzySet {
    static var empty: Self {
        .init(membershipFunction: .zero)
    }
    
    static var universe: Self {
        .init(membershipFunction: .one)
    }
}

// MARK: - From crisp set

public extension AnyFuzzySet where Universe: Hashable {
    static func fromCrispSet(_ set: Set<Universe>) -> Self {
        .init(membershipFunction: .fromCrispSet(set))
    }
}

// MARK: - Type erasure

public protocol AnyFuzzySetRepresentable: FuzzySet {
    func eraseToAnyFuzzySet() -> AnyFuzzySet<Universe>
}

extension AnyFuzzySet {
    public init<FS: AnyFuzzySetRepresentable>(_ fuzzySet: FS) where FS.Universe == Universe {
        self = fuzzySet.eraseToAnyFuzzySet()
    }
}

extension DiscreteMutableFuzzySet: AnyFuzzySetRepresentable {
    public func eraseToAnyFuzzySet() -> AnyFuzzySet<Universe> {
        .init(membershipFunction: .fromDictionary(grades))
    }
}

extension IterableFuzzySet: AnyFuzzySetRepresentable {
    public func eraseToAnyFuzzySet() -> AnyFuzzySet<Universe> {
        .init(membershipFunction: function)
    }
}
