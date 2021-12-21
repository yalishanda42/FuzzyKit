public struct IterableFuzzySet<Universe: Strideable> {
    
    public struct Element: Equatable {
        public let element: Universe
        public let grade: Grade
        
        public init(element: Universe, grade: Grade) {
            self.element = element
            self.grade = grade
        }
    }
    
    public typealias Iterator = Array<Element>.Iterator
    
    internal let range: StrideThrough<Universe>
    internal let function: MembershipFunction<Universe>
    
    public init(range: StrideThrough<Universe>, membershipFunction: MembershipFunction<Universe>) {
        self.range = range
        self.function = membershipFunction
    }
    
    public init(range: StrideThrough<Universe>, membershipFunction: @escaping MembershipFunction<Universe>.FunctionType) {
        self.range = range
        self.function = .init(membershipFunction)
    }
}

// MARK: - FuzzySet conformance

extension IterableFuzzySet: FuzzySet {
    public func grade(forElement element: Universe) -> Grade {
        function(element)
    }
    
    public func alphaCut(_ alpha: Grade) -> Self {
        .init(range: range) {
            Swift.max(function($0), alpha)
        }
    }
    
    public func complement(method: ComplementFunction = .standard) -> Self {
        .init(range: range) {
            method.function(function($0))
        }
    }
    
    public func intersection(_ other: Self, method: TNormFunction = .minimum) -> Self {
        .init(range: range) {
            method.function(function($0), other.function($0))
        }
    }
    
    public func union(_ other: Self, method: SNormFunction = .maximum) -> Self {
        .init(range: range) {
            method.function(function($0), other.function($0))
        }
    }
    
    public func difference(_ other: Self, method: DifferenceFunction = .tNormAndComplement(.minimum, .standard)) -> Self {
        .init(range: range) {
            method.function(function($0), other.function($0))
        }
    }
}

// MARK: - Sequence conformance

extension IterableFuzzySet: Sequence {
    public func makeIterator() -> Iterator {
        range
            .map { .init(
                element: $0,
                grade: grade(forElement: $0)
            )}
            .makeIterator()
    }
}
