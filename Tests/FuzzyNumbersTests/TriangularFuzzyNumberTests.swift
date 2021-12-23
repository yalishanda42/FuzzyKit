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
}
