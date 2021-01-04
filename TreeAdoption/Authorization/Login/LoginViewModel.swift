import Combine

protocol LoginViewEvents {
    func onAuthorised()
}

class LoginViewModel: ObservableObject {
    private let listener: LoginViewEvents
    private let authenticator: Authenticator
    private var loginCancellable: AnyCancellable?

    init(
        _ listener: LoginViewEvents,
        _ authenticator: Authenticator
    ) {
        self.listener = listener
        self.authenticator = authenticator
    }

    deinit {
        loginCancellable = nil
    }

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorVisible: Bool = false
}

extension LoginViewModel {
    func loginPressed() {
        if email.isEmpty || password.isEmpty {
            return
        }

        loginCancellable = authenticator.authorise(username: email, password: password)
            .sink { [unowned self] value in
                switch value {
                    case .success:
                        self.listener.onAuthorised()
                    case .failure:
                        self.errorVisible = true
                }
                loginCancellable = nil
            }
    }

    func onAuthorised() {
        listener.onAuthorised()
    }
}
