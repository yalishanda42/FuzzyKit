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
    
    private let range: StrideThrough<Universe>
    private let function: MembershipFunction<Universe>
    
    public init(range: StrideThrough<Universe>, membershipFunction: MembershipFunction<Universe>) {
        self.range = range
        self.function = membershipFunction
    }
    
    public init(range: StrideThrough<Universe>, membershipFunction: @escaping MembershipFunction<Universe>.FunctionType) {
        self.range = range
        self.function = .init(membershipFunction)
    }
    
    public func alphaCut(_ alpha: Grade) -> Self {
        .init(range: range) {
            Swift.max(function($0), alpha)
        }
    }
}

extension IterableFuzzySet: FuzzySet {
    public func grade(forElement element: Universe) -> Grade {
        function(element)
    }
}
    
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
