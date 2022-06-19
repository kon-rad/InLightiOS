import InLightMeditation
import XCTest
import ViewSnapshotTesting

class SnapshotTests: XCTestCase {
    func testPreviews() {
        verifySnapshot(SplashScreenView_Previews.previews)
        verifySnapshot(ContentView_Previews.previews)
        verifySnapshot(Profile_Previews.previews)
        verifySnapshot(EditTimeAlert_Previews.previews)
        verifySnapshot(TimerView_Previews.previews)
        verifySnapshot(CurrentStreak_Previews.previews)
    }
}
