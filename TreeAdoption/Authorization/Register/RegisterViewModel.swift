import Combine

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
}

extension RegisterViewModel {
    func registerPressed() {}
}
