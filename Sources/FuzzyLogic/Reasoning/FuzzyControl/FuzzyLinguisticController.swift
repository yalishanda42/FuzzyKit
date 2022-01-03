import FuzzySets
import FuzzyRelations

open class FuzzyLinguisticController<AntecedentUniverse, ConsequentUniverse> {
    
    public var settings: OperationSettings
    public var ruleBase: FuzzyRuleBase<(AntecedentUniverse, ConsequentUniverse)>
    public var aggregatorFuction: (Grade, Grade) -> Grade
    
    public init(
        rules: FuzzyRuleBase<(AntecedentUniverse, ConsequentUniverse)> = .init(),
        settings: OperationSettings = .init()
    ) {
        self.ruleBase = rules
        self.settings = settings
        self.aggregatorFuction = settings.disjunction.function
    }
    
    open func consequenceGrade<S: Sequence>(
        for value: ConsequentUniverse,
        usingFact fact: IterableFuzzySet<AntecedentUniverse, S>
    ) -> Grade {
        ruleBase
            .map {
                FuzzySetComposition(set: fact, relation: $0.asRelation())
            }
            .map {
                $0.grade(forElement: value)
            }
            .reduce(0, aggregatorFuction)
    }
}
