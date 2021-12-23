public struct DiscreteMutableFuzzySet<Universe: Hashable> {
    
    public private(set) var grades: [Universe: Grade]

    public init(elementToGradeMap: [Universe: Grade] = [:]) {
        self.grades = elementToGradeMap
    }
}

// MARK: - FuzzySet conformance

extension DiscreteMutableFuzzySet: FuzzySet {
    /// - Complexity: O(1)
    public func grade(forElement element: Universe) -> Grade {
        grades[element] ?? 0
    }
    
    public func alphaCut(_ alpha: Grade) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.applyAlphaCut(alpha)
        return result
    }
    
    public func complement(method: ComplementFunction = .standard) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.formComplement(method: method)
        return result
    }
    
    public func intersection(_ other: Self, method: TNormFunction = .minimum) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.formIntersection(other, method: method)
        return result
    }
    
    public func union(_ other: Self, method: SNormFunction) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.formUnion(other, method: method)
        return result
    }
    
    public func difference(_ other: Self, method: DifferenceFunction = .tNormAndComplement(.minimum, .standard)) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.formDifference(other, method: method)
        return result
    }
    
    public func symmetricDifference(_ other: Self, method: SymmetricDifferenceFunction = .absoluteValue) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.formSymmetricDifference(other, method: method)
        return result
    }
    
    public func power(_ n: Double) -> Self {
        var result = Self(elementToGradeMap: grades)
        result.applyPower(n)
        return result
    }
}

// MARK: - Mutability

public extension DiscreteMutableFuzzySet {
    /// - Complexity: O(1)
    mutating func setGrade(_ grade: Grade, forElement element: Universe) {
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
        applyFunction(method.function, whenMergingWith: other.grades)
    }
    
    mutating func formUnion(_ other: Self, method: SNormFunction = .maximum) {
        applyFunction(method.function, whenMergingWith: other.grades)
    }
    
    mutating func formDifference(_ other: Self, method: DifferenceFunction = .tNormAndComplement(.minimum, .standard)) {
        applyFunction(method.function, whenMergingWith: other.grades)
    }
    
    mutating func formSymmetricDifference(_ other: Self, method: SymmetricDifferenceFunction = .absoluteValue) {
        applyFunction(method.function, whenMergingWith: other.grades)
    }
    
    mutating func applyPower(_ n: Double) {
        applyFunction { Double.pow($0, n) }
    }
}

// MARK: - Properties

public extension DiscreteMutableFuzzySet {
    var support: Set<Universe> {
        let elements = grades
            .filter { $0.value > 0 }
            .map { $0.key }
        return Set(elements)
    }
    
    var core: Set<Universe> {
        let elements = grades
            .filter { $0.value == 1 }
            .map { $0.key }
        return Set(elements)
    }
    
    var height: Grade {
        grades.values.max() ?? 0
    }
    
    var isNormal: Bool {
        grades.values.contains { $0 == 1 }
    }
}

// MARK: - From crisp set
public extension DiscreteMutableFuzzySet {
    static func fromCrispSet(_ set: Set<Universe>) -> Self {
        let gradeTuples = set.map { ($0, 1.0 ) }
        let gradeDictionary = Dictionary(uniqueKeysWithValues: gradeTuples)
        return .init(elementToGradeMap: gradeDictionary)
    }
}

public extension Set {
    func fuzzified() -> DiscreteMutableFuzzySet<Set.Element> {
        DiscreteMutableFuzzySet.fromCrispSet(self)
    }
}

// MARK: - Helpers

private extension DiscreteMutableFuzzySet {
    mutating func applyFunction(_ function: (Grade) -> Grade) {
        let newGradeTuples = grades.map {
            ($0.key, function($0.value))
        }
        let newMap = Dictionary(uniqueKeysWithValues: newGradeTuples)
        grades = newMap
    }
    
    mutating func applyFunction(_ function: (Grade, Grade) -> Grade, whenMergingWith anotherDictionary: [Universe: Grade]) {
        grades.merge(anotherDictionary, uniquingKeysWith: function)
    }
}
