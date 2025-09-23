import XCTest
@testable import NumericsPlus

final class PolyfitEdgeCaseTests: XCTestCase {

    // MARK: - Log Transformation Edge Cases

    func testPolyfitWithZeroAndNegativeValues() {
        let x = (0..<5).map { Double($0) }
        let y = [0.0, -1.0, -2.0, -3.0, -4.0] // These would cause log to fail

        let results = Double.polyfit(x: x, y: y, degree: 1)

        // Should handle gracefully without NaN
        XCTAssertFalse(results.contains { $0.isNaN })
        print("Zero/negative values test: \(results)")
    }

    func testPolyfitWithVerySmallPositiveValues() {
        let x = (0..<5).map { Double($0) }
        let y = [1e-300, 1e-200, 1e-100, 1e-50, 1e-10] // Very small positive values

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        print("Very small values test: \(results)")
    }

    func testPolyfitWithVeryLargeValues() {
        let x = (0..<5).map { Double($0) }
        let y = [1e100, 1e150, 1e200, 1e250, 1e300] // Very large values

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        print("Very large values test: \(results)")
    }

    // MARK: - Data Collection Edge Cases

    func testPolyfitWithSingleElement() {
        let x = [0.0]
        let y = [1.0]

        // This should ideally throw an error rather than produce NaN
        let results = Double.polyfit(x: x, y: y, degree: 1)
        print("Single element test: \(results)")
    }

    func testPolyfitWithTwoElements() {
        let x = [0.0, 1.0]
        let y = [1.0, 2.0]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        XCTAssertEqual(results[0], 1.0, accuracy: 1e-10) // slope
        XCTAssertEqual(results[1], 1.0, accuracy: 1e-10) // intercept
        print("Two elements test: \(results)")
    }

    func testPolyfitWithDuplicateXValues() {
        let x = [0.0, 0.0, 1.0, 1.0, 2.0, 2.0]
        let y = [1.0, 1.1, 2.0, 2.1, 3.0, 3.1]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        print("Duplicate X values test: \(results)")
    }

    // MARK: - Numerical Precision Edge Cases

    func testPolyfitWithCollinearPoints() {
        let x = (0..<5).map { Double($0) }
        let y = [2.0, 2.0, 2.0, 2.0, 2.0] // All y values are the same

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        XCTAssertEqual(results[0], 0.0, accuracy: 1e-10) // slope should be 0
        print("Collinear points test: \(results)")
    }

    func testPolyfitWithNearCollinearPoints() {
        let x = (0..<5).map { Double($0) }
        let y = [2.0, 2.0000000001, 2.0000000002, 2.0000000003, 2.0000000004]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        print("Near collinear points test: \(results)")
    }

    func testPolyfitWithExtremeSlope() {
        let x = [0.0, 0.0000000001]
        let y = [0.0, 1e100]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        print("Extreme slope test: \(results)")
    }

    // MARK: - Financial Data Simulation

    func testPolyfitWithRealisticLogTransformedData() {
        // Simulate realistic financial data after log transformation
        let x = (0..<25).map { Double($0) }
        let y = [
            2.524848256880948, 2.524768183213131, 2.523245564014449, 2.530198638979707,
            2.5303579126919176, 2.5346487416828145, 2.534331533115523, 2.529800343678309,
            2.5282853730899455, 2.529083012120829, 2.536154109791838, 2.5388422834536386,
            2.54733356806064, 2.552487413608947, 2.5532659873013435, 2.560091422935765,
            2.5612502163753343, 2.5535772471279947, 2.5562966458746734, 2.554043955288302,
            2.548194389023919, 2.5467070506934473, 2.5549767186672407, 2.5618676909241285,
            2.5693243884259016
        ]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        XCTAssertFalse(results.contains { $0.isNaN })
        XCTAssertFalse(results.contains { !$0.isFinite })
        print("Realistic log-transformed data test: \(results)")
    }

    // MARK: - Input Validation Tests

    func testPolyfitWithMismatchedArraySizes() {
        let x = [0.0, 1.0, 2.0]
        let y = [1.0, 2.0] // Mismatched size

        // This should ideally throw an error
        let results = Double.polyfit(x: x, y: y, degree: 1)
        print("Mismatched array sizes test: \(results)")
    }

    func testPolyfitWithEmptyArrays() {
        let x: [Double] = []
        let y: [Double] = []

        // This should ideally throw an error
        let results = Double.polyfit(x: x, y: y, degree: 1)
        print("Empty arrays test: \(results)")
    }

    func testPolyfitWithNaNInput() {
        let x = [0.0, 1.0, 2.0]
        let y = [1.0, Double.nan, 3.0]

        let results = Double.polyfit(x: x, y: y, degree: 1)
        print("NaN input test: \(results)")
    }

    func testPolyfitWithInfinityInput() {
        let x = [0.0, 1.0, 2.0]
        let y = [1.0, Double.infinity, 3.0]

        let results = Double.polyfit(x: x, y: y, degree: 1)
        print("Infinity input test: \(results)")
    }

    // MARK: - Degree-specific Edge Cases

    func testPolyfitWithHighDegree() {
        let x = (0..<5).map { Double($0) }
        let y = [1.0, 2.0, 3.0, 4.0, 5.0]

        let results = Double.polyfit(x: x, y: y, degree: 4) // High degree for few points

        XCTAssertFalse(results.contains { $0.isNaN })
        print("High degree test: \(results)")
    }

    func testPolyfitWithDegreeZero() {
        let x = (0..<5).map { Double($0) }
        let y = [1.0, 2.0, 3.0, 4.0, 5.0]

        let results = Double.polyfit(x: x, y: y, degree: 0)

        XCTAssertFalse(results.contains { $0.isNaN })
        print("Degree zero test: \(results)")
    }
}