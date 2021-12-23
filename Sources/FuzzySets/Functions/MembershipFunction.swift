import RealModule

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
    static func rightOpen(slopeStart a: U, slopeEnd b: U) -> Self {
        assert(a < b, "Arguments do not satisfy `slopeStart < slopeEnd`!")
        return .init { u in
            switch u {
            case ..<a: return 0
            case a...b: return (u - a) / (b - a)
            default: return 1
            }
        }
    }
    
    static func leftOpen(slopeStart a: U, slopeEnd b: U) -> Self {
        assert(a < b, "Arguments do not satisfy `slopeStart < slopeEnd`!")
        return .init { u in
            switch u {
            case ..<a: return 1
            case a...b: return (b - u) / (b - a)
            default: return 0
            }
        }
    }
    
    static func triangular(minimum a: U, peak b: U, maximum c: U) -> Self {
        assert(a < b && b < c, "Arguments do not satisfy `minimum < peak < maximum`!")
        return .init { u in
            switch u {
            case a...b: return (u - a) / (b - a)
            case b...c: return (c - u) / (c - b)
            default: return 0
            }
        }
    }
    
    static func trapezoidal(
        leftSlopeStart a: U,
        leftSlopeEnd b: U,
        rightSlopeStart c: U,
        rightSlopeEnd d: U
    ) -> Self {
        assert(a < b && b < c && c < d, "Arguments do not satisfy `leftSlopeStart < leftSlopeEnd < rightSlopeStart < rightSlopeEnd`!")
        return .init { u in
            switch u {
            case a..<b: return (u - a) / (b - a)
            case b..<c: return 1
            case c...d: return (d - u) / (d - c)
            default: return 0
            }
        }
    }
    
    static func gaussian(mean c: Double = 0, stdev s: Double = 1) -> Self {
        .init { u in
            Double.exp(-((u - c).pow(2)) / (2 * s.pow(2)))
        }
    }
    
    static func bell(width a: Double, shape b: Double, center c: Double) -> Self {
        return .init { u in
            1 / (1 + abs((u - c) / a).pow(2*b))
        }
    }
    
    static func sigmoid(width a: Double, center c: Double) -> Self {
        return .init { u in
            1 / (1 + Double.exp(-a * (u - c)))
        }
    }
    
    // TODO: Add more
}
