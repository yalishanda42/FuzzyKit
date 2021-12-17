public struct DiscreteMutableFuzzySet<Universe: Hashable>: FuzzySet {
    
    public private(set) var grades: [Universe: Grade]

    public init(elementToGradeMap: [Universe: Grade] = [:]) {
        self.grades = elementToGradeMap
    }
    
    /// - Complexity: O(1)
    public func grade(forElement element: Universe) -> Grade {
        grades[element] ?? 0
    }
    
    /// - Complexity: O(1)
    public mutating func setGrade(_ grade: Grade, forElement element: Universe) {
        grades[element] = grade
    }
    
    public subscript(_ element: Universe) -> Grade {
        get {
            grade(forElement: element)
        }
        set {
            setGrade(newValue, forElement: element)
        }
    }
    
    public func alphaCut(_ alpha: Grade) -> Self {
        var newSet = Self(elementToGradeMap: grades)
        newSet.applyAlphaCut(alpha)
        return newSet
    }
    
    public mutating func applyAlphaCut(_ alpha: Grade) {
        let newGradeTuples = grades.map {
            ($0.key, min($0.value, alpha))
        }
        let newMap = Dictionary(uniqueKeysWithValues: newGradeTuples)
        grades = newMap
    }
}

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
