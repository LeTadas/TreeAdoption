import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
}

extension ForgotPasswordViewModel {
    func restPressed() {}
}
