import XCTest
import FuzzyRelations
import FuzzySets

final class FuzzyRelationsTests: XCTestCase {
    func test_cartesianProduct_discreteSets() {
        let fs1 = DiscreteMutableFuzzySet(elementToGradeMap: [
            "a1": 1,
            "a2": 0.6,
            "a3": 0.3,
        ])
        let fs2 = DiscreteMutableFuzzySet(elementToGradeMap: [
            "b1": 0.6,
            "b2": 0.9,
            "b3": 0.1,
        ])
        let expectedTuples = [
            ("a1", "b1"),
            ("a1", "b2"),
            ("a1", "b3"),
            ("a2", "b1"),
            ("a2", "b2"),
            ("a2", "b3"),
            ("a3", "b1"),
            ("a3", "b2"),
            ("a3", "b3"),
        ]
        let expectedGrades = [
            0.6,
            0.9,
            0.1,
            0.6,
            0.6,
            0.1,
            0.3,
            0.3,
            0.1,
        ]
        
        let sut = BinaryCartesianProduct(fs1, fs2)
        
        for (elements, grade) in zip(expectedTuples, expectedGrades) {
            XCTAssertApproximatelyEqual(grade, sut[elements.0, elements.1])
            XCTAssertApproximatelyEqual(grade, sut.grade(forElements: elements))
        }
    }
    
    func test_customRelation_discreteSets() {
        let sut = BinaryFuzzyRelation { (a: Int, b: Int) -> Grade in
            switch abs(a - b) {
            case 0: return 1
            case 1: return 0.8
            case 2: return 0.3
            default: return 0
            }
        }
        
        let expectedTuples = [
            (1, 1),
            (1, 2),
            (1, 3),
            (2, 1),
            (2, 2),
            (2, 3),
            (3, 1),
            (3, 2),
            (3, 3),
        ]
        let expectedGrades = [
            1,
            0.8,
            0.3,
            0.8,
            1.0,
            0.8,
            0.3,
            0.8,
            1.00,
        ]
        
        for (elements, grade) in zip(expectedTuples, expectedGrades) {
            XCTAssertApproximatelyEqual(grade, sut[elements.0, elements.1])
            XCTAssertApproximatelyEqual(grade, sut.grade(forElements: elements))
        }
    }
}
