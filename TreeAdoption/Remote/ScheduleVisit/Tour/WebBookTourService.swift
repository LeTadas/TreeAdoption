import Combine
import Foundation

class WebBookTourService {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func bookATour(id: Int) -> AnyPublisher<Result<WebForestResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/forest/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultNewsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let request = BookTourRequest(
            tourId: 0,
            userId: 0,
            userName: "",
            userEmail: "",
            bookedDateTime: ""
        )

        return networkClient.execute(url: urlRequest)
    }
}
