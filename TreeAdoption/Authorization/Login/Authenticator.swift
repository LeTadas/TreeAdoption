import Combine

class Authenticator {
    private let webLoginService: LoginService
    private let tokenArchiver: TokenArchiver

    init(
        _ webLoginService: LoginService,
        _ tokenArchiver: TokenArchiver
    ) {
        self.webLoginService = webLoginService
        self.tokenArchiver = tokenArchiver
    }

    func authorise(username: String, password: String) -> AnyPublisher<Result<Void, RequestError>, Never> {
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
