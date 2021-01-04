import Combine

protocol MainTabViewEvents {
    func onLoggedOut()
}

class MainTabViewModel: ObservableObject {
    private let listener: MainTabViewEvents

    init(_ listener: MainTabViewEvents) {
        self.listener = listener
    }
}

extension MainTabViewModel {
    func onLoggedOut() {
        listener.onLoggedOut()
    }
}
