import FuzzySets

public struct FuzzyRuleBase<RuleInput> {
    
    public typealias Rule = FuzzyRule<RuleInput>
    
    @resultBuilder
    public struct FuzzyRuleBaseBuilder {
        public static func buildBlock() -> [Rule] { [] }
        
        public static func buildBlock(_ rules: Rule...) -> [Rule] { rules }
        
        public static func buildOptional(_ component: [Rule]?) -> [Rule] {
            component ?? []
        }
        
        public static func buildEither(first component: [Rule]) -> [Rule] {
            component
        }
        
        public static func buildEither(second component: [Rule]) -> [Rule] {
            component
        }
        
        public static func buildArray(_ components: [[Rule]]) -> [Rule] {
            components.flatMap { $0 }
        }
    }
    
    public var rules: [Rule]
    
    public init(_ rules: [Rule] = []) {
        self.rules = rules
    }
    
    public init(@FuzzyRuleBaseBuilder _ rulesBlock: () -> [Rule]) {
        self.rules = rulesBlock()
    }
}

extension FuzzyRuleBase: Sequence {
    public func makeIterator() -> Array<Rule>.Iterator {
        rules.makeIterator()
    }
}
