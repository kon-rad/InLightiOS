import InLightMeditation
import XCTest
import ViewSnapshotTesting

class SnapshotTests: XCTestCase {
    func testPreviews() {
        verifySnapshot(SplashScreenView_Previews.previews)
    }
}
