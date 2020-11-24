import Combine
import Foundation

protocol LauncherViewEvents {
    func onAuthenticated()
    func onUnauthenticated()
}

class LauncherViewModel: ObservableObject {
    private let listener: LauncherViewEvents

    init(_ listener: LauncherViewEvents) {
        self.listener = listener
    }
}

extension LauncherViewModel {
    func onAppear() {
        listener.onAuthenticated()
    }
}
