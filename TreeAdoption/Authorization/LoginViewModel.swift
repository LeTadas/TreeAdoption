import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}

extension LoginViewModel {
    func loginPressed() {}
    func forgotPasswordPressed() {}
    func noAccountPressed() {}
}
