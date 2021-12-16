public struct MembershipFunction {
    
    private let function: (Double) -> Double
    
    public init(_ function: @escaping (Double) -> Grade) {
        self.function = function
    }
    
    public func callAsFunction(_ x: Double) -> Double {
        function(x)
    }
}

/// Common membership functions
public extension MembershipFunction {
    static var zero: Self {
        .init { _ in 0.0 }
    }
    
    static var one: Self {
        .init { _ in 1.0 }
    }
    
    static func fuzzySingleton(_ a: Double) -> Self {
        .init { $0 == a ? 1.0 : 0.0 }
    }
    
    // TODO: Add more
}
