import XCTest
import FuzzyKit

final class MembershipFunctionTests: XCTestCase {
    func test_isCallable() throws {
        let sut = MembershipFunction<Void>.one
        
        let result = sut(())
        
        XCTAssertApproximatelyEqual(result, 1.0)
    }
}
