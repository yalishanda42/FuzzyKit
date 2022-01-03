import XCTest
import FuzzyLogic
import FuzzySets

final class ControlTests: XCTestCase {
    func test_staffingRules_consequenceDegreesAreCorrect() {
        enum Funding { case adequate, marginal, inadequate }
        enum Staffing { case small, large }
        enum Risk { case low, normal, high }
        
        let funding: SimpleLinguisticVariable<Funding, AnyFuzzySet> = [
            .inadequate: .init(membershipFunction: .leftOpen(slopeStart: 15, slopeEnd: 35)),
            .marginal: .init(membershipFunction: .triangular(minimum: 21, peak: 41, maximum: 61)),
            .adequate: .init(membershipFunction: .rightOpen(slopeStart: 55, slopeEnd: 75)),
        ]
        
        let staffing: SimpleLinguisticVariable<Staffing, AnyFuzzySet> = [
            .small: .init(membershipFunction: .leftOpen(slopeStart: 29, slopeEnd: 69)),
            .large: .init(membershipFunction: .rightOpen(slopeStart: 37, slopeEnd: 77)),
        ]
        
        let risk: SimpleLinguisticVariable<Risk, AnyFuzzySet> = [
            .low: .init(membershipFunction: .leftOpen(slopeStart: 20, slopeEnd: 40)),
            .normal: .init(membershipFunction: .triangular(minimum: 20, peak: 50, maximum: 80)),
            .high: .init(membershipFunction: .rightOpen(slopeStart: 60, slopeEnd: 80)),
        ]
        
        let Ø = AnyFuzzySet<Double>.empty
        
        let ruleBase = FuzzyRuleBase {
            funding.is(.adequate) || staffing.is(.small) --> risk.is(.low)
            funding.is(.marginal) && staffing.is(.large) --> risk.is(.normal)
            funding.is(.inadequate) || Ø --> risk.is(.high)
        }
        
        let sut = FuzzyLogicController(rules: ruleBase)
        let sut2 = FuzzyLogicController(rules: ruleBase, settings: .init(implication: .larsen))
        
        let tuple = (8.8, 42.0)
        let fact = IterableFuzzySet.singleton(tuple)
        
        let result1 = sut.consequenceGrade(for: 100, usingFact: fact)
        let result2 = sut.consequenceGrade(for: 0, usingFact: fact)
        let result3 = sut.consequenceGrade(for: 50, usingFact: fact)
        let result11 = sut.consequenceGrade(for: 100, usingSingletonFact: tuple)
        let result22 = sut.consequenceGrade(for: 0, usingSingletonFact: tuple)
        let result33 = sut.consequenceGrade(for: 50, usingSingletonFact: tuple)
        
        let result4 = sut2.consequenceGrade(for: 100, usingFact: fact)
        let result5 = sut2.consequenceGrade(for: 0, usingFact: fact)
        let result6 = sut2.consequenceGrade(for: 50, usingFact: fact)
        
        XCTAssertApproximatelyEqual(1.0, result1)
        XCTAssertApproximatelyEqual(0.675, result2)
        XCTAssertApproximatelyEqual(0.0, result3)
        XCTAssertApproximatelyEqual(1.0, result11)
        XCTAssertApproximatelyEqual(0.675, result22)
        XCTAssertApproximatelyEqual(0.0, result33)
        XCTAssertApproximatelyEqual(1.0, result4)
        XCTAssertApproximatelyEqual(0.675, result5)
        XCTAssertApproximatelyEqual(0.0, result6)
    }
}
