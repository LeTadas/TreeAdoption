import Combine

protocol OnboardingViewEvents {
    func onAuthorised()
}

class OnboardingViewModel: ObservableObject {
    private let listener: OnboardingViewEvents

    init(_ listener: OnboardingViewEvents) {
        self.listener = listener
    }
}

extension OnboardingViewModel {
    func onAuthorised() {
        listener.onAuthorised()
    }
}
