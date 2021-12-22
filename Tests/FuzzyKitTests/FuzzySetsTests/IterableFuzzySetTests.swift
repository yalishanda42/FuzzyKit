import XCTest
import FuzzyKit

class IterableFuzzySetTests: XCTestCase {
    private var near4Support4: [IterableFuzzySet<Int, StrideThrough<Int>>.Element] = [
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
        let range = stride(from: 0, through: 10, by: 1)
        
        let sut = IterableFuzzySet(range) {
            expected[$0].grade
        }
        
        let result = Array(sut)
        
        XCTAssertEqual(result, expected)
    }
    
    func test_initFromDoubleRangeAndContinuousFunction() {
        let expected = near4Support4.map {
            IterableFuzzySet<Double, StrideThrough<Double>>.Element(
                element: Double($0.element),
                grade: $0.grade
            )
        }
        
        let sut = IterableFuzzySet(
            stride(from: 0.0, through: 10.0, by: 1),
            membershipFunction: .triangular(minimum: 0.0, peak: 4.0, maximum: 8.0)
        )
        
        let result = Array(sut)
        
        XCTAssertEqual(result, expected)
    }
    
    func test_alphaCut_allValuesAreBelowAlpha() {
        let alpha = 0.5
        let set = IterableFuzzySet(
            stride(from: 0.0, through: 100.0, by: 0.5),
            membershipFunction: .triangular(minimum: 42.0, peak: 69.0, maximum: 88.88)
        )
        
        let sut = set.alphaCut(alpha)
        
        let grades = Array(sut).map { $0.grade }
        let allAreBelowAlpha = grades.allSatisfy { $0 >= alpha }
        XCTAssertTrue(allAreBelowAlpha)
    }
    
    func test_complementOfTriangular_allValuesAddUpToOne() {
        let set = IterableFuzzySet(
            stride(from: 0.0, through: 100.0, by: 0.5),
            membershipFunction: .triangular(minimum: 42.0, peak: 69.0, maximum: 88.88)
        )
        
        let sut = set.complement()
        
        let sums = zip(set, sut).map { $0.0.grade + $0.1.grade }
        
        sums.forEach { XCTAssertApproximatelyEqual(1.0, $0) }
    }
}
