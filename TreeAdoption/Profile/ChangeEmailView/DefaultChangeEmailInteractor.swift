import Combine

class DefaultChangeEmailInteractor {
    private let webUserService: WebUserService
    private let loginService: LoginService

    init(
        _ webUserService: WebUserService,
        _ loginService: LoginService
    ) {
        self.webUserService = webUserService
        self.loginService = loginService
    }

    func changeEmail(
        password: String,
        username: String,
        newEmail: String
    ) -> AnyPublisher<Result<Void, RequestError>, Never> {
        return loginService.login(username: username, password: password)
            .flatMap { [unowned self] (value: Result<LoginResponse, RequestError>) -> AnyPublisher<Result<Void, RequestError>, Never> in
                switch value {
                    case let .success(result):
                        TokenArchiver.shared.storeAccessToken(token: result.accessToken)
                        TokenArchiver.shared.storeRefreshToken(token: result.refreshToken)
                        return self.webUserService.updateEmail(email: newEmail)
                    case let .failure(error):
                        return Just(Result.failure(RequestError.genericError(error))).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
