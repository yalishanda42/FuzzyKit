import XCTest
import FuzzySets

public func XCTAssertApproximatelyEqual(_ v1: Double, _ v2: Double, tolerance: Double = 0.0001) {
    let diff = v1 - v2
    XCTAssert(-tolerance <= diff && diff <= +tolerance)
}

public func assertExpectedGrade<E, S: FuzzySet>(element: E, expectedGrade: Grade, sut: S)
where S.Universe == E {
    let grade1 = sut[element]
    let grade2 = sut.grade(forElement: element)
    
    XCTAssertApproximatelyEqual(grade1, grade2)
    XCTAssertApproximatelyEqual(expectedGrade, grade1)
    XCTAssertApproximatelyEqual(expectedGrade, grade2)
}
