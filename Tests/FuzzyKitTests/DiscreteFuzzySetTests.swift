import XCTest
import FuzzyKit

final class DiscreteFuzzySetTests: XCTestCase {
    func test_defaultInit_allGradesAreZero() throws {
        let sut = DiscreteFuzzySet<String>()
        
        let expected = [
            "a": 0.0,
            "b": 0.0,
            "c": 0.0,
        ]
        
        for (element, grade) in expected {
            assertExpectedGrade(element: element, expectedGrade: grade, sut: sut)
        }
    }
    
    func test_initWithParams_gradesAreCorrect() throws {
        let parameters = [
            "a": 0.69,
            "c": 1.0,
        ]
        
        let sut = DiscreteFuzzySet(elementToGradeMap: parameters)
        
        let expected = [
            "a": 0.69,
            "b": 0.0,
            "c": 1.0,
        ]
        
        for (element, grade) in expected {
            assertExpectedGrade(element: element, expectedGrade: grade, sut: sut)
        }
    }
    
    func test_setGrade_gradesAreCorrect() throws {
        var sut1 = DiscreteFuzzySet<String>()
        var sut2 = DiscreteFuzzySet<String>()
        
        let expected = [
            "a": 0.69,
            "b": 0.0,
            "c": 1.0,
        ]
        
        for (element, grade) in expected {
            if grade == 0 { continue }
            sut1.setGrade(grade, forElement: element)
        }
        
        for (element, grade) in expected {
            if grade == 0 { continue }
            sut2[element] = grade
        }
        
        for (element, grade) in expected {
            assertExpectedGrade(element: element, expectedGrade: grade, sut: sut1)
            assertExpectedGrade(element: element, expectedGrade: grade, sut: sut2)
        }
    }
}
