import CoreGraphics
public struct MembershipFunction<U> {
    
    public typealias FunctionType = (U) -> Grade
    
    private let function: FunctionType
    
    public init(_ function: @escaping FunctionType) {
        self.function = function
    }
    
    public func callAsFunction(_ u: U) -> Grade {
        function(u)
    }
}

/// Common membership functions
public extension MembershipFunction {
    static var zero: Self {
        .init { _ in 0 }
    }
    
    static var one: Self {
        .init { _ in 1 }
    }
}

public extension MembershipFunction where U: Equatable {
    static func fuzzySingleton(_ onlyMember: U) -> Self {
        .init { $0 == onlyMember ? 1 : 0 }
    }
}

public extension MembershipFunction where U: Hashable {
    static func fromCrispSet(_ set: Set<U>) -> Self {
        .init { set.contains($0) ? 1 : 0 }
    }
    
    static func fromDictionary(_ dictionary: [U: Grade]) -> Self {
        .init { dictionary[$0] ?? 0 }
    }
}

public extension MembershipFunction where U == Double {
    static func triangular(minimum a: U, peak b: U, maximum c: U) -> Self {
        .init { u in
            switch u {
            case a...b: return (u - a) / (b - a)
            case b...c: return (c - u) / (c - b)
            default: return 0
            }
        }
    }
    
    // TODO: Add more
}
