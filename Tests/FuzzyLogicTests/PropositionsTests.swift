import XCTest
import FuzzySets
import FuzzyLogic

final class PropositionTests: XCTestCase {
    func test_operators_appliedCorrectly() {
        enum Person {
            case alice
            case bob
        }
        let grades: [Person: Grade] = [
            .alice: 0.8,
            .bob: 0.6,
        ]
        let efficient = DiscreteMutableFuzzySet(grades)
        
        let sut1 = !efficient
        let sut2 = efficient && efficient
        let sut3 = efficient || efficient
        let sut4 = efficient --> efficient
        let sut5 = efficient ^^ efficient
        
        let result1 = sut1(.alice)
        let result2 = sut2((.alice, .bob))
        let result3 = sut3((.alice, .bob))
        let result4 = sut4((.alice, .bob))
        let result5 = sut5((.alice, .bob))
        
        XCTAssertApproximatelyEqual(result1, 0.2)
        XCTAssertApproximatelyEqual(result2, 0.6)
        XCTAssertApproximatelyEqual(result3, 0.8)
        XCTAssertApproximatelyEqual(result4, 0.6)
        XCTAssertApproximatelyEqual(result5, 0.2)
    }
    
    func test_operatorsNesting_appliedCorrectly() {
        enum Person {
            case alice
            case bob
        }
        let grades: [Person: Grade] = [
            .alice: 0.8,
            .bob: 0.6,
        ]
        let efficient = DiscreteMutableFuzzySet(grades)
        
        let sut = efficient || efficient --> efficient
        
        let result = sut(((.alice, .bob), .bob))
        
        XCTAssertApproximatelyEqual(result, 0.6)
    }
}
