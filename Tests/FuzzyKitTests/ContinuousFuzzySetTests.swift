import XCTest
import FuzzyKit

final class ContinuousFuzzySetTests: XCTestCase {
    func test_triangular_alphaCut() {
        let a = 3.0
        let b = 5.0
        let c = 8.0
        let alpha = 0.5
        let set = ContinuousFuzzySet(membershipFunction: .triangular(minimum: a, peak: b, maximum: c))
        
        let sut = set.alphaCut(alpha)
        let minResult = sut[a]
        let peakResult = sut[b]
        let maxResult = sut[c]
        
        XCTAssertEqual(0, minResult)
        XCTAssertEqual(alpha, peakResult)
        XCTAssertEqual(0, maxResult)
    }
}
