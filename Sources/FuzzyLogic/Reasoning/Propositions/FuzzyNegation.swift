import FuzzySets

public struct FuzzyNegation<FS: FuzzyProposition>: FuzzyProposition {
    
    public let statement: FS
    
    public init(_ statement: FS) {
        self.statement = statement
    }
    
    public func apply(_ value: FS.U, settings: OperationSettings = .init()) -> Grade {
        settings.negation.function(statement(value, settings: settings))
    }
}


public prefix func ! <FS: FuzzyProposition>(statement: FS) -> FuzzyNegation<FS> {
    .init(statement)
}
