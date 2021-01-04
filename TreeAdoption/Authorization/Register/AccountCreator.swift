import Combine

class AccountCreator {
    private let webCreateAccountService: CreateAccountService
    private let webUserDetailsService: WebUserDetailsService
    private let webLoginService: LoginService
    private let tokenArchiver: TokenArchiver
    private let userPersister: UserPersister

    init(
        _ webCreateAccountService: CreateAccountService,
        _ webUserDetailsService: WebUserDetailsService,
        _ webLoginService: LoginService,
        _ tokenArchiver: TokenArchiver,
        _ userPersister: UserPersister
    ) {
        self.webCreateAccountService = webCreateAccountService
        self.webUserDetailsService = webUserDetailsService
        self.webLoginService = webLoginService
        self.tokenArchiver = tokenArchiver
        self.userPersister = userPersister
    }

    func register(registerInfo: RegisterInfo) -> AnyPublisher<Result<Void, RequestError>, Never> {
        return webCreateAccountService
            .register(registerInfo)
            .flatMap { [unowned self] value -> AnyPublisher<Result<Void, RequestError>, Never> in
                switch value {
                    case .success:
                        return self.authorise(
                            username: registerInfo.userName,
                            password: registerInfo.password
                        )
                    case let .failure(error):
                        return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func authorise(username: String, password: String) -> AnyPublisher<Result<Void, RequestError>, Never> {
        return webLoginService
            .login(username: username, password: password)
            .flatMap { [unowned self] value -> AnyPublisher<Result<Void, RequestError>, Never> in
                switch value {
                    case let .success(response):
                        self.tokenArchiver.storeAccessToken(token: response.accessToken)
                        self.tokenArchiver.storeRefreshToken(token: response.refreshToken)
                        return self.resultsFor(token: response.accessToken)
                    case let .failure(error):
                        return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func resultsFor(token: String) -> AnyPublisher<Result<Void, RequestError>, Never> {
        return webUserDetailsService.getDetails(token: token)
            .map { value in
                switch value {
                    case let .success(result):
                        self.userPersister.storeUser(
                            user: User(
                                id: result.id,
                                firstName: result.firstname,
                                lastName: result.lastname,
                                userName: result.username,
                                email: result.email
                            )
                        )
                        return .success(())
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
