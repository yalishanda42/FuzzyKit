import XCTest
import FuzzySets

func XCTAssertApproximatelyEqual(_ v1: Double, _ v2: Double, tolerance: Double = 0.0001) {
    let diff = v1 - v2
    XCTAssert(-tolerance <= diff && diff <= +tolerance)
}
