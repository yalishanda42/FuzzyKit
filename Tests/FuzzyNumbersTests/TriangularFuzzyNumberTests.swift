import XCTest
import FuzzyNumbers

final class TriangularFuzzyNumberTests: XCTestCase {
    func test_addition() {
        let a = TriangularFuzzyNumber(minimum: -3, peak: 2, maximum: 4)
        let b = TriangularFuzzyNumber(minimum: -1, peak: 0, maximum: 6)
        let expect = TriangularFuzzyNumber(minimum: -4, peak: 2, maximum: 10)
        
        let result = a + b
        
        XCTAssertEqual(result, expect)
    }
    
    func test_subtraction() {
        let a = TriangularFuzzyNumber(minimum: -3, peak: 2, maximum: 4)
        let b = TriangularFuzzyNumber(minimum: -1, peak: 0, maximum: 6)
        let expect = TriangularFuzzyNumber(minimum: -9, peak: 2, maximum: 5)
        
        let result = a - b
        
        XCTAssertEqual(result, expect)
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
