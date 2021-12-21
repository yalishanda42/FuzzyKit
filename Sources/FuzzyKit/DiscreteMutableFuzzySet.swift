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
        result.formComplement()
        return result
    }
    
    public func intersection(_ other: Self, method: TNormFunction = .minimum) -> Self {
        let combined = grades.merging(other.grades, uniquingKeysWith: method.function)
        return .init(elementToGradeMap: combined)
    }
    
    public func union(_ other: Self, method: SNormFunction) -> Self {
        let combined = grades.merging(other.grades, uniquingKeysWith: method.function)
        return .init(elementToGradeMap: combined)
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
        let combined = grades.merging(other.grades, uniquingKeysWith: method.function)
        grades = combined
    }
    
    mutating func formIntersection(_ other: Self, method: SNormFunction = .maximum) {
        let combined = grades.merging(other.grades, uniquingKeysWith: method.function)
        grades = combined
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
}
