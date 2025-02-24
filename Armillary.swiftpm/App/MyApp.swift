import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.white)
                .preferredColorScheme(.light)
                .onAppear(perform: {
                    hideTitleBarOnCatalyst()
                })
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}

func hideTitleBarOnCatalyst() {
    #if targetEnvironment(macCatalyst)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.titlebar?.titleVisibility = .hidden
    #endif
}
