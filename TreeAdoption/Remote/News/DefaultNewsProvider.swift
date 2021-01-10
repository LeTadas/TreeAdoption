import Combine
import Foundation

protocol NewsProvider {
    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never>
}

class DefaultNewsProvider: NewsProvider {
    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return NetworkClient.shared.execute(url: urlRequest)
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
