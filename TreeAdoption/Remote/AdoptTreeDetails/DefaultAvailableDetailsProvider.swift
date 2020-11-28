import Combine
import Foundation

protocol AvailableDetailsProvider {
    func getDetails(id: String) -> AnyPublisher<Result<WebAdoptTreeDetailsResponse, RequestError>, Never>
}

class DefaultAvailableDetailsProvider: AvailableDetailsProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getDetails(id: String) -> AnyPublisher<Result<WebAdoptTreeDetailsResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/product/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultAvailableDetailsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
    }
}
