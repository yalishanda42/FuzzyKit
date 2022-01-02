public struct DiscreteMutableFuzzySet<Universe: Hashable>: ExpressibleByDictionaryLiteral {
    
    public private(set) var grades: [Universe: Grade]
    public private(set) var defaultGrade: Grade

    public init(_ elementToGradeMap: [Universe: Grade], defaultGrade: Grade = 0) {
        self.grades = elementToGradeMap
        self.defaultGrade = defaultGrade
    }
    
    public init(dictionaryLiteral elements: (Universe, Grade)...) {
        self.grades = .init(uniqueKeysWithValues: elements)
        self.defaultGrade = 0
    }
}

// MARK: - Fuzzy set

extension DiscreteMutableFuzzySet: FuzzySet {
    /// - Complexity: O(1)
    public func grade(forElement element: Universe) -> Grade {
        grades[element] ?? defaultGrade
    }
}

// MARK: - Fuzzy set operations

extension DiscreteMutableFuzzySet: FuzzySetOperations {
    public func alphaCut(_ alpha: Grade) -> Self {
        var result = self
        result.applyAlphaCut(alpha)
        return result
    }
    
    public func complement(method: ComplementFunction = .standard) -> Self {
        var result = self
        result.formComplement(method: method)
        return result
    }
    
    public func intersection(_ other: Self, method: TNormFunction = .minimum) -> Self {
        var result = self
        result.formIntersection(other, method: method)
        return result
    }
    
    public func union(_ other: Self, method: SNormFunction) -> Self {
        var result = self
        result.formUnion(other, method: method)
        return result
    }
    
    public func difference(_ other: Self, method: DifferenceFunction = .tNormAndComplement(.minimum, .standard)) -> Self {
        var result = self
        result.formDifference(other, method: method)
        return result
    }
    
    public func symmetricDifference(_ other: Self, method: SymmetricDifferenceFunction = .absoluteValue) -> Self {
        var result = self
        result.formSymmetricDifference(other, method: method)
        return result
    }
    
    public func power(_ n: Double) -> Self {
        var result = self
        result.applyPower(n)
        return result
    }
    
    public func appliedCustomFunction(_ function: @escaping (Grade) -> Grade) -> Self {
        var result = self
        result.applyFunction(function)
        return result
    }
}

// MARK: - Mutability

public extension DiscreteMutableFuzzySet {
    /// - Complexity: O(1)
    mutating func setGrade(_ grade: Grade, forElement element: Universe) {
        guard grade != defaultGrade else { return }
        grades[element] = grade
    }
    
    subscript(_ element: Universe) -> Grade {
        get {
            grade(forElement: element)
        }
        set {
            setGrade(newValue, forElement: element)
        }
    }
    
    mutating func applyAlphaCut(_ alpha: Grade) {
        applyFunction { max($0, alpha) }
    }
    
    mutating func formComplement(method: ComplementFunction = .standard) {
        applyFunction(method.function)
    }
    
    mutating func formIntersection(_ other: Self, method: TNormFunction = .minimum) {
        applyFunction(method.function, whenMergingWith: other)
    }
    
    mutating func formUnion(_ other: Self, method: SNormFunction = .maximum) {
        applyFunction(method.function, whenMergingWith: other)
    }
    
    mutating func formDifference(_ other: Self, method: DifferenceFunction = .tNormAndComplement(.minimum, .standard)) {
        applyFunction(method.function, whenMergingWith: other)
    }
    
    mutating func formSymmetricDifference(_ other: Self, method: SymmetricDifferenceFunction = .absoluteValue) {
        applyFunction(method.function, whenMergingWith: other)
    }
    
    mutating func applyPower(_ n: Double) {
        applyFunction { Double.pow($0, n) }
    }
}

// MARK: - Properties

public extension DiscreteMutableFuzzySet {
    var support: Set<Universe> {
        assert(defaultGrade == 0, "Cannot compute core of DiscreteMutableFuzzySet with defaultGrade > 0")

        let elements = grades
            .filter { $0.value > 0 }
            .map { $0.key }
        return Set(elements)
    }
    
    var core: Set<Universe> {
        assert(defaultGrade != 1, "Cannot compute core of DiscreteMutableFuzzySet with defaultGrade==1")
        
        let elements = grades
            .filter { $0.value == 1 }
            .map { $0.key }
        return Set(elements)
    }
    
    var height: Grade {
        guard let maximum = grades.values.max() else {
            return defaultGrade
        }
        return max(defaultGrade, maximum)
    }
    
    var isNormal: Bool {
        guard defaultGrade != 1 else { return true }
        return grades.values.contains { $0 == 1 }
    }
}

// MARK: - From crisp set

public extension DiscreteMutableFuzzySet {
    static func fromCrispSet(_ set: Set<Universe>) -> Self {
        let gradeTuples = set.map { ($0, 1.0 ) }
        let gradeDictionary = Dictionary(uniqueKeysWithValues: gradeTuples)
        return .init(gradeDictionary)
    }
}

// MARK: - Debug

extension DiscreteMutableFuzzySet: CustomStringConvertible {
    public var description: String {
        let guts = grades.map {
            "\($0.value)/\($0.key)"
        }.joined(separator: ", ")
        return "<FuzzySet: {\(guts)}, other values == \(defaultGrade)>"
    }
}

// MARK: - Helpers

extension DiscreteMutableFuzzySet {
    public mutating func applyFunction(_ function: (Grade) -> Grade) {
        let newGradeTuples = grades.map {
            ($0.key, function($0.value))
        }
        let newMap = Dictionary(uniqueKeysWithValues: newGradeTuples)
        grades = newMap
        defaultGrade = function(defaultGrade)
        sanitize()
    }
    
    public mutating func applyFunction(
        _ function: (Grade, Grade) -> Grade,
        whenMergingWith anotherSet: Self
    ) {
        grades.merge(anotherSet.grades, uniquingKeysWith: function)
        defaultGrade = function(defaultGrade, anotherSet.defaultGrade)
        sanitize()
    }
    
    private mutating func sanitize() {
        grades = grades.filter {
            $0.value != defaultGrade
        }
    }
}
