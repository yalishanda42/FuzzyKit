import XCTest
import FuzzyKit

class IterableFuzzySetTests: XCTestCase {
    private var near4Support4: [IterableFuzzySet<Int>.Element] = [
        .init(element: 0, grade: 0.0),
        .init(element: 1, grade: 0.25),
        .init(element: 2, grade: 0.50),
        .init(element: 3, grade: 0.75),
        .init(element: 4, grade: 1.0),
        .init(element: 5, grade: 0.75),
        .init(element: 6, grade: 0.50),
        .init(element: 7, grade: 0.25),
        .init(element: 8, grade: 0.0),
        .init(element: 9, grade: 0.0),
        .init(element: 10, grade: 0.0),
    ]
    
    func test_initFromIntRangeAndDiscreteFunction() {
        let expected = near4Support4
        
        let sut = IterableFuzzySet(
            range: stride(from: 0, through: 10, by: 1),
            membershipFunction: .init {
                expected[$0].grade
            }
        )
        
        let result = Array(sut)
        
        XCTAssertEqual(result, expected)
    }
    
    func test_initFromIntRangeAndContinuousFunction() {
        let expected = near4Support4.map {
            IterableFuzzySet<Double>.Element(element: Double($0.element), grade: $0.grade)
        }
        
        let sut = IterableFuzzySet(
            range: stride(from: 0.0, through: 10.0, by: 1),
            membershipFunction: .triangular(minimum: 0.0, peak: 4.0, maximum: 8.0)
        )
        
        let result = Array(sut)
        
        XCTAssertEqual(result, expected)
    }
}
