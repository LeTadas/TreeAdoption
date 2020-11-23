import SwiftUI

@main
struct TreeAdoptionApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .onAppear {
                    UINavigationBar.appearance().tintColor = UIColor(named: "primaryColor")
                }
        }
    }
}
