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
        
        XCTAssertEqual(alpha, minResult)
        XCTAssertEqual(1.0, peakResult)
        XCTAssertEqual(alpha, maxResult)
    }
    
    func test_triangular_complement() {
        let a = 3.0
        let b = 5.0
        let c = 8.0
        let set = ContinuousFuzzySet(membershipFunction: .triangular(minimum: a, peak: b, maximum: c))
        
        let sut = set.complement
        let minResult = sut[a]
        let peakResult = sut[b]
        let maxResult = sut[c]
        
        XCTAssertEqual(1.0, minResult)
        XCTAssertEqual(0.0, peakResult)
        XCTAssertEqual(1.0, maxResult)
    }
}
