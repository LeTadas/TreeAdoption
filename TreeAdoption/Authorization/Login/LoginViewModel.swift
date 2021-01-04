import Combine

protocol LoginViewEvents {
    func onAuthorised()
}

class LoginViewModel: ObservableObject {
    private let listener: LoginViewEvents

    init(_ listener: LoginViewEvents) {
        self.listener = listener
    }

    @Published var email: String = ""
    @Published var password: String = ""
}

extension LoginViewModel {
    func loginPressed() {}
    func onAuthorised() {
        listener.onAuthorised()
    }
}
