import Combine
import Foundation

class WebUserDetailsService {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getDetails(token: String) -> AnyPublisher<Result<UserDetailsResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/user")

        guard let requestUrl = url else {
            fatalError("Could not parse url LoginService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return networkClient.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }
}
