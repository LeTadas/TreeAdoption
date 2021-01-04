import Combine

class AccountCreator {
    private let webCreateAccountService: CreateAccountService
    private let webLoginService: LoginService
    private let tokenArchiver: TokenArchiver

    init(
        _ webCreateAccountService: CreateAccountService,
        _ webLoginService: LoginService,
        _ tokenArchiver: TokenArchiver
    ) {
        self.webCreateAccountService = webCreateAccountService
        self.webLoginService = webLoginService
        self.tokenArchiver = tokenArchiver
    }

    func register(registerInfo: RegisterInfo) -> AnyPublisher<Result<Void, RequestError>, Never> {
        return webCreateAccountService
            .register(registerInfo)
            .flatMap { [unowned self] _ in
                self.authorise(
                    username: registerInfo.userName,
                    password: registerInfo.password
                )
            }
            .eraseToAnyPublisher()
    }

    private func authorise(username: String, password: String) -> AnyPublisher<Result<Void, RequestError>, Never> {
        return webLoginService
            .login(username: username, password: password)
            .map { [unowned self] value in
                switch value {
                    case let .success(response):
                        self.tokenArchiver.storeAccessToken(token: response.accessToken)
                        self.tokenArchiver.storeRefreshToken(token: response.refreshToken)
                        return .success(())
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
