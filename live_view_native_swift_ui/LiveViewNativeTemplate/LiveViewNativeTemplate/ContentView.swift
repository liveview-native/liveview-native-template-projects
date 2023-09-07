import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        LiveView(
            .automatic(URL(string: Bundle.main.object(forInfoDictionaryKey: "Phoenix Production URL") as? String ?? "example.com")!)
        )
    }
}
