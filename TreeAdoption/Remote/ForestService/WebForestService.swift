import Combine
import Foundation

class WebForestService {
    func getForest(id: Int) -> AnyPublisher<Result<WebForestResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/forest/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
    }

    func getAvailableForests() -> AnyPublisher<Result<[WebForestResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/forest")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
    }
}
