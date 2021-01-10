import Combine
import Foundation

enum AppState {
    case launcher
    case onboarding
    case main
}

class AppViewModel: ObservableObject {
    @Published var state: AppState = .launcher
    @Published var paymentStatusVisible: Bool = false
}

extension AppViewModel {
    func handleUrl(url: URL) {
        if url.host! == "payment-return" {
            paymentStatusVisible = true
        }
    }

    func onAuthenticated() {
        state = .main
    }

    func onUnauthenticated() {
        state = .onboarding
    }
}
