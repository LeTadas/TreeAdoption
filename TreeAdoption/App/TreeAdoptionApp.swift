import SwiftUI

@main
struct TreeAdoptionApp: App {
    @ObservedObject var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            switch viewModel.state {
                case .launcher:
                    LauncherView(
                        viewModel: LauncherViewModel(
                            LauncherViewListener(viewModel)
                        )
                    )
                case .onboarding:
                    OnboardingView()
                case .main:
                    EmptyView()
            }
        }
    }
}

private class LauncherViewListener: LauncherViewEvents {
    private unowned let viewModel: AppViewModel

    init(_ viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    func onAuthenticated() {
        viewModel.onUnauthenticated()
    }

    func onUnauthenticated() {
        viewModel.onUnauthenticated()
    }
}
