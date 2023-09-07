import SwiftUI
import LiveViewNative

struct ContentView: View {
    static let productionURL = (Bundle.main.object(forInfoDictionaryKey: "Phoenix Production URL") as? String)
        .flatMap(URL.init) ?? URL(string: "example.com")!
    
    var body: some View {
        LiveView(
            .automatic(development: .localhost, production: .custom(Self.productionURL))
        )
    }
}
