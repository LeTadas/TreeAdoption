import Combine
import Foundation

protocol NewsDetailsProvider {
    func getNewsDetails(id: String) -> AnyPublisher<Result<NewsItem, RequestError>, Never>
}

class DefaultNewsDetailsProvider: NewsDetailsProvider {
    func getNewsDetails(id: String) -> AnyPublisher<Result<NewsItem, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsDetailsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
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
