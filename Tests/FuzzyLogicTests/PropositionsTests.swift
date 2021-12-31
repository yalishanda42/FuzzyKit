import XCTest
import FuzzySets
import FuzzyRelations
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
    
    func test_linguisticVariableInOperator_gradesAreCorrect() {
        enum Temperature { case high }
        enum Pressure { case low }
        let highTemperature = DiscreteMutableFuzzySet([
            20: 0.2,
            25: 0.4,
            30: 0.6,
            35: 0.6,
            40: 0.7,
            45: 0.8,
            50: 0.8,
        ])
        let lowPressure = DiscreteMutableFuzzySet([
            1: 0.8,
            2: 0.8,
            3: 0.6,
            4: 0.4,
        ])
        let temperature = LinguisticVariable([
            Temperature.high: highTemperature
        ])
        let pressure = LinguisticVariable([
            Pressure.low: lowPressure
        ])
        
        let sut = temperature(is: .high) --> pressure(is: .low)
        let sut2 = temperature.is(.high) --> pressure.is(.low)
        
        let expectedRelation = BinaryFuzzyRelation
            .implication(antecedent: highTemperature, consequent: lowPressure)
            .eraseToAnyFuzzySet()
            .makeIterable(over: zip(stride(from: 20, through: 50, by: 5), 1...4))
        
        for pair in expectedRelation {
            XCTAssertApproximatelyEqual(sut(pair.element), pair.grade)
            XCTAssertApproximatelyEqual(sut2(pair.element), pair.grade)
        }
    }
}
