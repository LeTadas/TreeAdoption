import Combine

protocol RegisterViewEvents {
    func onAuthorised()
}

class RegisterViewModel: ObservableObject {
    private let accountCreator: AccountCreator
    private let listener: RegisterViewEvents

    private var registerCancellable: AnyCancellable?

    init(
        _ accountCreator: AccountCreator,
        _ listener: RegisterViewEvents
    ) {
        self.accountCreator = accountCreator
        self.listener = listener
    }

    deinit {
        registerCancellable = nil
    }

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var errorVisible: Bool = false
}

extension RegisterViewModel {
    func registerPressed() {
        if
            firstName.isEmpty ||
            lastName.isEmpty ||
            userName.isEmpty ||
            email.isEmpty ||
            password.isEmpty
        {
            return
        }

        if password != repeatPassword {
            return
        }

        let registerInfo = RegisterInfo(
            firstName: firstName,
            lastName: lastName,
            userName: userName,
            email: email,
            password: password
        )

        registerCancellable = accountCreator.register(registerInfo: registerInfo)
            .sink { [unowned self] value in
                switch value {
                    case .success:
                        self.listener.onAuthorised()
                    case .failure:
                        self.errorVisible = true
                }
                registerCancellable = nil
            }
    }
}
