import Combine
import Foundation

class WebForestService {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getForest(id: Int) -> AnyPublisher<Result<WebForestResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/forest/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
    }
}
