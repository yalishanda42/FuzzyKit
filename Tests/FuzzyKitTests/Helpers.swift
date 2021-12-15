import XCTest
import FuzzyKit

func assertExpectedGrade<E, S: FuzzySet>(element: E, expectedGrade: Grade, sut: S)
where S.Element == E {
    let grade1 = sut[element]
    let grade2 = sut.grade(forElement: element)
    
    XCTAssertEqual(grade1, grade2)
    XCTAssertEqual(expectedGrade, grade1)
    XCTAssertEqual(expectedGrade, grade2)
}
