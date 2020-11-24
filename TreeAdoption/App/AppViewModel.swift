import Combine

enum AppState {
    case launcher
    case onboarding
    case main
}

class AppViewModel: ObservableObject {
    @Published var state: AppState = .launcher
}

extension AppViewModel {
    func onAuthenticated() {
        state = .main
    }

    func onUnauthenticated() {
        state = .onboarding
    }
}
