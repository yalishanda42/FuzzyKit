import XCTest
import FuzzyKit

final class AnyFuzzySetTests: XCTestCase {
    func test_initFromDiscreteMutableFuzzySet() {
        let expected = [
            "a": 1.0,
            "b": 0.88,
            "c": 0.69,
            "d": 0.42,
            "e": 0.0001,
            "f": 0.0,
        ]
        
        let set = DiscreteMutableFuzzySet(elementToGradeMap: expected)
        
        let sut = set.eraseToAnyFuzzySet()
        
        for (element, grade) in expected {
            assertExpectedGrade(element: element, expectedGrade: grade, sut: sut)
        }
    }
    
    func test_initFromIterableFuzzySet() {
        let range = stride(from: 0, through: 10, by: 0.5)
        let function = MembershipFunction.triangular(minimum: 42, peak: 69, maximum: 88)
        let set = IterableFuzzySet(range: range, membershipFunction: function)
        
        let sut = set.eraseToAnyFuzzySet()
        
        for element in range {
            let result = sut[element]
            let expected = function(element)
            XCTAssertApproximatelyEqual(expected, result)
        }
    }
    
    func test_triangular_alphaCut() {
        let a = 3.0
        let b = 5.0
        let c = 8.0
        let alpha = 0.5
        let set = AnyFuzzySet(membershipFunction: .triangular(minimum: a, peak: b, maximum: c))
        
        let sut = set.alphaCut(alpha)
        let minResult = sut[a]
        let peakResult = sut[b]
        let maxResult = sut[c]
        
        XCTAssertEqual(alpha, minResult)
        XCTAssertEqual(1.0, peakResult)
        XCTAssertEqual(alpha, maxResult)
    }
    
    func test_triangular_complement() {
        let a = 3.0
        let b = 5.0
        let c = 8.0
        let set = AnyFuzzySet(membershipFunction: .triangular(minimum: a, peak: b, maximum: c))
        
        let sut = set.complement
        let minResult = sut[a]
        let peakResult = sut[b]
        let maxResult = sut[c]
        
        XCTAssertEqual(1.0, minResult)
        XCTAssertEqual(0.0, peakResult)
        XCTAssertEqual(1.0, maxResult)
    }
}
