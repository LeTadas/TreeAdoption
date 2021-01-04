import Combine

class Authenticator {
    private let webLoginService: LoginService
    private let webUserDetailsService: WebUserDetailsService
    private let tokenArchiver: TokenArchiver
    private let userPersister: UserPersister

    init(
        _ webLoginService: LoginService,
        _ webUserDetailsService: WebUserDetailsService,
        _ tokenArchiver: TokenArchiver,
        _ userPersister: UserPersister
    ) {
        self.webLoginService = webLoginService
        self.webUserDetailsService = webUserDetailsService
        self.tokenArchiver = tokenArchiver
        self.userPersister = userPersister
    }

    func authorise(username: String, password: String) -> AnyPublisher<Result<Void, RequestError>, Never> {
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
