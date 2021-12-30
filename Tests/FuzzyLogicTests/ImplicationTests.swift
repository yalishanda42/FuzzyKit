import XCTest
import FuzzyLogic
import FuzzySets

final class ImplicationTests: XCTestCase {
    func test_basicStandardStrictExample() {
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
        
        XCTAssertApproximatelyEqual(sut(4, 1), 0.75)
        XCTAssertApproximatelyEqual(sut(4, 1, method: .standardStrict), 1)
    }
}
