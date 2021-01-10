import Firebase
import Sniffer
import SwiftUI

@main
struct TreeAdoptionApp: App {
    @ObservedObject var viewModel = AppViewModel()

    init() {
        Sniffer.register()
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            switch viewModel.state {
                case .launcher:
                    LauncherView(
                        viewModel: LauncherViewModel(
                            LauncherViewListener(viewModel),
                            TokenArchiver()
                        )
                    )
                case .onboarding:
                    OnboardingView(
                        viewModel: OnboardingViewModel(OnboardingViewListener(viewModel))
                    )
                case .main:
                    MainTabView(viewModel: MainTabViewModel(MainTabViewListener(viewModel)))
                        .onOpenURL(perform: viewModel.handleUrl)
                        .sheet(isPresented: $viewModel.paymentStatusVisible) {
                            NavigationView {
                                PaymentStatusView(
                                    viewModel: PaymentStatusViewModel(WebOrderServiceProvider())
                                )
                                .navigationBarItems(trailing:
                                    Button("payment_status_view_done_button_title") { viewModel.paymentStatusVisible.toggle()
                                    }
                                )
                            }
                        }
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
        viewModel.onAuthenticated()
    }

    func onUnauthenticated() {
        viewModel.onUnauthenticated()
    }
}

private class OnboardingViewListener: OnboardingViewEvents {
    private unowned let viewModel: AppViewModel

    init(_ viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    func onAuthorised() {
        viewModel.onAuthenticated()
    }
}

private class MainTabViewListener: MainTabViewEvents {
    private unowned let viewModel: AppViewModel

    init(_ viewModel: AppViewModel) {
        self.viewModel = viewModel
    }

    func onLoggedOut() {
        viewModel.onUnauthenticated()
    }
}
