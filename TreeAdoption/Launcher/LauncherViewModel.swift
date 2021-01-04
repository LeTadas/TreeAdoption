import Combine
import Foundation

protocol LauncherViewEvents {
    func onAuthenticated()
    func onUnauthenticated()
}

class LauncherViewModel: ObservableObject {
    private let listener: LauncherViewEvents
    private let tokenArchiver: TokenArchiver

    init(
        _ listener: LauncherViewEvents,
        _ tokenArchiver: TokenArchiver
    ) {
        self.listener = listener
        self.tokenArchiver = tokenArchiver
    }
}

extension LauncherViewModel {
    func onAppear() {
        if tokenArchiver.getAccessToken() == nil || tokenArchiver.getRefreshToken() == nil {
            listener.onUnauthenticated()
            return
        }

        listener.onAuthenticated()
    }
}
