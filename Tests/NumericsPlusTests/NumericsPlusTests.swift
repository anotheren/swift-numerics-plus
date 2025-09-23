import XCTest
@testable import NumericsPlus

final class NumericsPlusTests: XCTestCase {
    
    func testPolyfit() {
        let x = [
            0.0,
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            10.0,
            11.0,
            12.0,
            13.0,
            14.0,
            15.0,
            16.0,
            17.0,
            18.0,
            19.0,
            20.0,
            21.0,
            22.0,
            23.0,
            24.0,
        ]
        let y = [
            1.376749,
            1.373969,
            1.372195,
            1.375233,
            1.381031,
            1.371181,
            1.360464,
            1.360464,
            1.363537,
            1.367112,
            1.366347,
            1.367112,
            1.377001,
            1.369402,
            1.364815,
            1.371688,
            1.371942,
            1.381533,
            1.381533,
            1.373209,
            1.374475,
            1.377001,
            1.377758,
            1.376244,
            1.382788,
        ]

        let results1 = Double.polyfit(x: x, y: y, degree: 1)
        XCTAssertEqual(results1[0], 0.000314715033628878, accuracy: 1e-06)
        XCTAssertEqual(results1[1], 1.3688147369507466, accuracy: 1e-06)
        
        let results2 = Double.polyfit(x: x, y: y, degree: 2)
        XCTAssertEqual(results2[0], 7.198023039759369e-05, accuracy: 1e-06)
        XCTAssertEqual(results2[1], -0.0014128240254310206, accuracy: 1e-06)
        XCTAssertEqual(results2[2], 1.3754369700104756, accuracy: 1e-06)
    }
    
    func testVariance() {
        let y = [
            1.376749,
            1.373969,
            1.372195,
            1.375233,
            1.381031,
            1.371181,
            1.360464,
            1.360464,
            1.363537,
            1.367112,
            1.366347,
            1.367112,
            1.377001,
            1.369402,
            1.364815,
            1.371688,
            1.371942,
            1.381533,
            1.381533,
            1.373209,
            1.374475,
            1.377001,
            1.377758,
            1.376244,
            1.382788,
        ]

        let results1 = Double.variance(y, ddof: 1)
        XCTAssertEqual(results1, 4.138910915034214e-05, accuracy: 1e-06)
    }

    func testPolyfitWithFinancialData() {
        let x = (0..<25).map { Double($0) }
        let y = [
            2.524848256880948,
            2.524768183213131,
            2.523245564014449,
            2.530198638979707,
            2.5303579126919176,
            2.5346487416828145,
            2.534331533115523,
            2.529800343678309,
            2.5282853730899455,
            2.529083012120829,
            2.536154109791838,
            2.5388422834536386,
            2.54733356806064,
            2.552487413608947,
            2.5532659873013435,
            2.560091422935765,
            2.5612502163753343,
            2.5535772471279947,
            2.5562966458746734,
            2.554043955288302,
            2.548194389023919,
            2.5467070506934473,
            2.5549767186672407,
            2.5618676909241285,
            2.5693243884259016,
        ]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        // Verify results are not NaN
        XCTAssertFalse(results[0].isNaN, "Slope should not be NaN")
        XCTAssertFalse(results[1].isNaN, "Intercept should not be NaN")

        // Verify results are finite
        XCTAssert(results[0].isFinite, "Slope should be finite")
        XCTAssert(results[1].isFinite, "Intercept should be finite")

        // Expected values for linear regression on this financial data
        XCTAssertEqual(results[0], 0.0016996787736693567, accuracy: 1e-06)
        XCTAssertEqual(results[1], 2.5229630805967957, accuracy: 1e-05)
    }

    func testPolyfitWithFinancialData2() {
        let x = (0..<25).map { Double($0) }
        let y = [
            4.909119230903745,
            4.909296310855805,
            4.909436476915929,
            4.909547120455751,
            4.909023299502002,
            4.9087649768999215,
            4.907494535176743,
            4.907110130186572,
            4.906348276107643,
            4.90806347898857,
            4.908144730258166,
            4.908137344051906,
            4.907538880091496,
            4.906607223672208,
            4.905637675546271,
            4.905156252896036,
            4.902597122641659,
            4.901296505222535,
            4.903888632997388,
            4.901541893960424,
            4.90322081865463,
            4.905171069357125,
            4.905141436215417,
            4.905163661154021,
            4.905282185818402,
        ]

        let results = Double.polyfit(x: x, y: y, degree: 1)

        // Verify results are not NaN
        XCTAssertFalse(results[0].isNaN, "Slope should not be NaN")
        XCTAssertFalse(results[1].isNaN, "Intercept should not be NaN")

        // Verify results are finite
        XCTAssert(results[0].isFinite, "Slope should be finite")
        XCTAssert(results[1].isFinite, "Intercept should be finite")

        // Expected values for this financial data
        XCTAssertEqual(results[0], -0.00027061080141055967, accuracy: 1e-06)
        XCTAssertEqual(results[1], 4.909596500358142, accuracy: 1e-05)
    }
}
