import Combine
import Foundation

protocol NewsProvider {
    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never>
}

class DefaultNewsProvider: NewsProvider {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return networkClient.execute(url: urlRequest)
            .map { (value: Result<[WebNewsResponse], RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(
                            result.map {
                                NewsItem(
                                    id: $0.contentId,
                                    createdAt: $0.createdAt,
                                    title: $0.title,
                                    content: $0.content
                                )
                            }
                        )
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
