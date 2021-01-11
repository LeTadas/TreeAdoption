import Combine

class ChangeEmailViewModel: ObservableObject {
    private let defaultChangeEmailInteractor: DefaultChangeEmailInteractor
    private var updateEmailCancellable: AnyCancellable?

    init(_ defaultChangeEmailInteractor: DefaultChangeEmailInteractor) {
        self.defaultChangeEmailInteractor = defaultChangeEmailInteractor
    }

    deinit {
        updateEmailCancellable = nil
    }

    @Published var username: String = "" {
        didSet {
            updateButton()
        }
    }

    @Published var newEmail: String = "" {
        didSet {
            updateButton()
        }
    }

    @Published var repeatNewEmail: String = "" {
        didSet {
            updateButton()
        }
    }

    @Published var password: String = "" {
        didSet {
            updateButton()
        }
    }

    @Published var buttonDisabled: Bool = true

    private func updateButton() {
        if
            username.isEmpty,
            newEmail.isEmpty,
            repeatNewEmail.isEmpty,
            password.isEmpty
        {
            buttonDisabled = true
            return
        }

        if newEmail != repeatNewEmail {
            buttonDisabled = true
            return
        }

        buttonDisabled = false
    }

    @Published var alertVisible: Bool = false
    var alertType: ChangeEmailAlert = .success
}

enum ChangeEmailAlert {
    case success
    case error
}

extension ChangeEmailViewModel {
    func onChangePressed() {
        if username.isEmpty { return }
        if newEmail.isEmpty { return }
        if repeatNewEmail.isEmpty { return }
        if password.isEmpty { return }

        updateEmailCancellable = defaultChangeEmailInteractor
            .changeEmail(password: password, username: username, newEmail: newEmail)
            .sink { [unowned self] value in
                switch value {
                    case .success:
                        self.alertType = .success
                        self.alertVisible = true
                    case .failure:
                        self.alertType = .error
                        self.alertVisible = true
                }
                self.updateEmailCancellable = nil
            }
    }
}
