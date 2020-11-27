import Combine
import Foundation

protocol NewsProvider {
    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never>
}

class DefaultNewsProvider: NewsProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
            .map { (value: Result<[WebNewsResponse], RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(
                            result.map {
                                NewsItem(
                                    id: $0.id,
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
