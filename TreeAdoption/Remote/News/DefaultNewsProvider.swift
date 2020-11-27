import Combine
import Foundation

protocol NewsProvider {
    func getNews() -> AnyPublisher<Result<[WebNewsResponse], RequestError>, Never>
}

class DefaultNewsProvider: NewsProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getNews() -> AnyPublisher<Result<[WebNewsResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/content")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest).eraseToAnyPublisher()
    }
}
