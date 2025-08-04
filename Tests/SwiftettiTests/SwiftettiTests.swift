import XCTest
@testable import Swiftetti

final class SwiftettiTests: XCTestCase {
    func testDefaultSettings() throws {
        let settings = SwiftettiSettings.default()
        XCTAssertEqual(settings.particleCount, 150)
        XCTAssertEqual(settings.maxTotalParticles, 500)
    }
    
    func testCelebrationSettings() throws {
        let settings = SwiftettiSettings.celebration()
        XCTAssertEqual(settings.particleCount, 200)
        XCTAssertEqual(settings.maxTotalParticles, 500)
    }
    
    func testColorHexInit() throws {
        let color = Color(hex: "FF0000")
        XCTAssertNotNil(color)
    }
}