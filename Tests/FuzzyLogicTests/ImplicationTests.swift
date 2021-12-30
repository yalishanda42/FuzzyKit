import XCTest
import FuzzyLogic
import FuzzyRelations
import FuzzySets

final class ImplicationTests: XCTestCase {
    func test_relationBasicStandardStrictExample() {
        let bigPressure = IterableFuzzySet(1...5) {
            switch $0 {
            case 5...: return 1
            case 1...5: return 1.0 - Double(5 - $0) / 4.0
            default: return 0
            }
        }
        let smallVolume = IterableFuzzySet(1...5) {
            switch $0 {
            case ...1: return 1
            case 1...5: return 1.0 - Double($0 - 1) / 4.0
            default: return 0
            }
        }
        
        let sut1 = BinaryFuzzyRelation.implication(antecedent: bigPressure, consequent: smallVolume)
        let sut2 = BinaryFuzzyRelation.implication(antecedent: bigPressure, consequent: smallVolume, method: .standardStrict)
        
        XCTAssertApproximatelyEqual(sut1(4, 1), 0.75)
        XCTAssertApproximatelyEqual(sut2(4, 1), 1)
    }
    
    func test_ruleBasicStandardStrictExample() {
        let bigPressure = IterableFuzzySet(1...5) {
            switch $0 {
            case 5...: return 1
            case 1...5: return 1.0 - Double(5 - $0) / 4.0
            default: return 0
            }
        }
        let smallVolume = IterableFuzzySet(1...5) {
            switch $0 {
            case ...1: return 1
            case 1...5: return 1.0 - Double($0 - 1) / 4.0
            default: return 0
            }
        }
        
        let sut = bigPressure --> smallVolume
        
        XCTAssertApproximatelyEqual(sut((4, 1)), 0.75)
        XCTAssertApproximatelyEqual(sut((4, 1), settings: .init(implication: .standardStrict)), 1)
    }
}
