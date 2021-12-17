public struct DiscreteMutableFuzzySet<Universe: Hashable>: FuzzySet {
    
    private var grades: [Universe: Grade]

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
