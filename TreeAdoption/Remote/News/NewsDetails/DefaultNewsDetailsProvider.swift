import Combine
import Foundation

protocol NewsDetailsProvider {
    func getNewsDetails(id: String) -> AnyPublisher<Result<NewsItem, RequestError>, Never>
}

class DefaultNewsDetailsProvider: NewsDetailsProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getNewsDetails(id: String) -> AnyPublisher<Result<NewsItem, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsDetailsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
            .map { (value: Result<[WebNewsResponse], RequestError>) in
                switch value {
                    case let .success(result):
                        let item = result.first!
                        return .success(
                            NewsItem(
                                id: item.id,
                                createdAt: item.createdAt,
                                title: item.title,
                                content: item.content
                            )
                        )
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
