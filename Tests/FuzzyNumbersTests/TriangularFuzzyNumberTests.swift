import XCTest
import FuzzyNumbers

extension TriangularFuzzyNumber {
    func approximatelyEqualTo(_ other: Self, tolerance: Double = 0.0001) -> Bool {
        abs(minimum - other.minimum) <= tolerance
        && abs(peak - other.peak) <= tolerance
        && abs(maximum - other.maximum) <= tolerance
    }
}

final class TriangularFuzzyNumberTests: XCTestCase {
    func test_addition() {
        let a = TriangularFuzzyNumber(minimum: -3, peak: 2, maximum: 4)
        let b = TriangularFuzzyNumber(minimum: -1, peak: 0, maximum: 6)
        let expect = TriangularFuzzyNumber(minimum: -4, peak: 2, maximum: 10)
        
        let result = a + b
        
        XCTAssert(result.approximatelyEqualTo(expect))
    }
    
    func test_subtraction() {
        let a = TriangularFuzzyNumber(minimum: -3, peak: 2, maximum: 4)
        let b = TriangularFuzzyNumber(minimum: -1, peak: 0, maximum: 6)
        let expect = TriangularFuzzyNumber(minimum: -9, peak: 2, maximum: 5)
        
        let result = a - b
        
        XCTAssert(result.approximatelyEqualTo(expect))
    }
    
    func test_alphaCutSumAndSubtraction() {
        let a = TriangularFuzzyNumber(minimum: -3, peak: 2, maximum: 4)
        let b = TriangularFuzzyNumber(minimum: -1, peak: 0, maximum: 6)
        let expect0Sum = TriangularFuzzyNumber(minimum: -4, peak: 2, maximum: 10)
        let expect1Sum = TriangularFuzzyNumber(minimum: 2, peak: 2, maximum: 2)
        let expect0Sub = TriangularFuzzyNumber(minimum: -9, peak: 2, maximum: 5)
        let expect1Sub = TriangularFuzzyNumber(minimum: 2, peak: 2, maximum: 2)
        
        let result0Sum = a.alphaCut(0) + b.alphaCut(0)
        let result1Sum = a.alphaCut(1) + b.alphaCut(1)
        let result0Sub = a.alphaCut(0) - b.alphaCut(0)
        let result1Sub = a.alphaCut(1) - b.alphaCut(1)
        
        XCTAssert(result0Sum.approximatelyEqualTo(expect0Sum))
        XCTAssert(result1Sum.approximatelyEqualTo(expect1Sum))
        XCTAssert(result0Sub.approximatelyEqualTo(expect0Sub))
        XCTAssert(result1Sub.approximatelyEqualTo(expect1Sub))
    }
    
//    func test_approximateMultiplication() {
//        let a = TriangularFuzzyNumber(minimum: 1, peak: 2, maximum: 4)
//        let b = TriangularFuzzyNumber(minimum: 2, peak: 4, maximum: 6)
//        let expect = TriangularFuzzyNumber(minimum: 2, peak: 8, maximum: 14)
//
//        let result = a.approximatelyMultiplied(by: b)
//
//        XCTAssertEqual(result, expect)
//    }
//
//    func test_approximateDivision() {
//        let a = TriangularFuzzyNumber(minimum: 1, peak: 2, maximum: 4)
//        let b = TriangularFuzzyNumber(minimum: 2, peak: 4, maximum: 6)
//        let expect = TriangularFuzzyNumber(minimum: 1/6, peak: 0.5, maximum: 2)
//
//        let result = a.approximatelyDivided(by: b)
//
//        XCTAssertEqual(result, expect)
//    }
}
