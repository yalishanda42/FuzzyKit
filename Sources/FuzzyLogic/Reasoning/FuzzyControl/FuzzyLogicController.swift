import FuzzySets
import FuzzyRelations

open class FuzzyLogicController<AntecedentUniverse, ConsequentUniverse> {
    
    public var settings: OperationSettings
    public var ruleBase: FuzzyRuleBase<(AntecedentUniverse, ConsequentUniverse)>
    public var aggregatorFunction: (Grade, Grade) -> Grade
    
    public init(
        rules: FuzzyRuleBase<(AntecedentUniverse, ConsequentUniverse)> = .init(),
        settings: OperationSettings = .init(),
        aggregatorFunction: ((Grade, Grade) -> Grade)? = nil
    ) {
        self.ruleBase = rules
        self.settings = settings
        self.aggregatorFunction = aggregatorFunction ?? settings.disjunction.function
    }
    
    open func consequence<S: Sequence>(
        usingFact fact: IterableFuzzySet<AntecedentUniverse, S>
    ) -> AnyFuzzySet<ConsequentUniverse> {
        ruleBase
            .map {
                FuzzySetComposition(set: fact, relation: $0.asRelation())
                    .eraseToAnyFuzzySet()
            }
            .reduce(AnyFuzzySet<ConsequentUniverse>.empty) { partialResult, currentSet in
                .init { [aggregatorFunction] element in
                     aggregatorFunction(partialResult(element), currentSet(element))
                }
            }
    }
    
    /// Apply generalized Modus Ponens to all rules using `fact` as input to the controller and return the grade membership of `value` in the fuzzy set output.
    open func consequenceGrade<S: Sequence>(
        for value: ConsequentUniverse,
        usingFact fact: IterableFuzzySet<AntecedentUniverse, S>
    ) -> Grade {
        ruleBase
            .map {
                FuzzySetComposition(set: fact, relation: $0.asRelation())
                    .grade(forElement: value)
            }
            .reduce(0, aggregatorFunction)
    }
    
    /// Apply generalized Modus Ponens to all rules using `fact` as input to the controller and return the grade membership of `value` in the fuzzy set output.
    ///
    /// Helper for the scenario when `AntecedentUniverse` does not conform to `Equatable`.
    /// One such example might be having a tuple as a universe of discourse - they still do not conform to `Equatable`, even if all of their elements are `Equatable`.
    open func consequenceGrade(
        for value: ConsequentUniverse,
        usingSingletonFact fact: AntecedentUniverse
    ) -> Grade {
        consequenceGrade(for: value, usingFact: .init([fact], membershipFunction: .one))
    }
}
