import XCTest
import FuzzyKit

final class MembershipFunctionTests: XCTestCase {
    func test_isCallable() throws {
        let sut = MembershipFunction<Double>.one
        let x = 1.0
        
        let result = sut(x)
        
        XCTAssertEqual(result, x)
    }
}
