import InLightMeditation
import XCTest
import ViewSnapshotTesting

class SnapshotTests: XCTestCase {
    func testPreviews() {
        verifySnapshot(SplashScreenView_Previews.previews, "SplashScreen")
        verifySnapshot(ContentView_Previews.previews, "ContentView")
        verifySnapshot(Profile_Previews.previews, "Profile")
        verifySnapshot(EditTimeAlert_Previews.previews)
        verifySnapshot(TimerView_Previews.previews, "TimerView")
        verifySnapshot(CurrentStreak_Previews.previews)
    }
}
