public struct DiscreteFuzzySet<Universe: Hashable>: FuzzySet {
    
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
