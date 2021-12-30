import XCTest
import FuzzySets

func XCTAssertApproximatelyEqual(_ v1: Double, _ v2: Double, tolerance: Double = 0.0001) {
    let diff = v1 - v2
    XCTAssert(-tolerance <= diff && diff <= +tolerance)
}

func assertExpectedGrade<E, S: FuzzySet>(element: E, expectedGrade: Grade, sut: S)
where S.Universe == E {
    let grade1 = sut[element]
    let grade2 = sut.grade(forElement: element)
    let grade3 = sut(element)
    
    XCTAssertApproximatelyEqual(grade1, grade2)
    XCTAssertApproximatelyEqual(grade2, grade3)
    XCTAssertApproximatelyEqual(grade1, grade3)
    XCTAssertApproximatelyEqual(expectedGrade, grade1)
    XCTAssertApproximatelyEqual(expectedGrade, grade2)
    XCTAssertApproximatelyEqual(expectedGrade, grade3)
}
