import FuzzySets

public struct FuzzyNegation<Input>: FuzzyProposition {
    
    public let function: (Input, OperationSettings) -> Grade
    
    public init<F: FuzzyProposition>(_ statement: F) where Input == F.Input {
        self.function = { (input, settings) -> Grade in
            settings.negation.function(statement(input, settings: settings))
        }
    }
    
    public func apply(_ value: Input, settings: OperationSettings = .init()) -> Grade {
        function(value, settings)
    }
}


public prefix func ! <F: FuzzyProposition>(statement: F) -> FuzzyNegation<F.Input> {
    .init(statement)
}
