import Combine
import Foundation

class WebForestService {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func getForest(id: Int) -> AnyPublisher<Result<WebForestResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/forest/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return networkClient.execute(url: urlRequest)
    }
}
