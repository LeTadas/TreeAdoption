import Combine
import Foundation

protocol NewsDetailsProvider {
    func getNewsDetails(id: String) -> AnyPublisher<Result<NewsItem, RequestError>, Never>
}

class DefaultNewsDetailsProvider: NewsDetailsProvider {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func getNewsDetails(id: String) -> AnyPublisher<Result<NewsItem, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsDetailsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return networkClient.execute(url: urlRequest)
            .map { (value: Result<WebNewsResponse, RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(
                            NewsItem(
                                id: result.contentId,
                                createdAt: result.createdAt,
                                title: result.title,
                                content: result.content
                            )
                        )
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
