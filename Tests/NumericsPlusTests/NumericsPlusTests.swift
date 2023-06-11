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
}
