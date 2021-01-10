import Combine
import Foundation

protocol AvailableDetailsProvider {
    func getDetails(id: String) -> AnyPublisher<Result<AdoptTreeDetails, RequestError>, Never>
}

class DefaultAvailableDetailsProvider: AvailableDetailsProvider {
    func getDetails(id: String) -> AnyPublisher<Result<AdoptTreeDetails, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/product/\(id)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultAvailableDetailsProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return NetworkClient.shared.execute(url: urlRequest)
            .map { (value: Result<WebAdoptTreeDetailsResponse, RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(
                            AdoptTreeDetails(
                                id: result.id,
                                name: result.name,
                                description: result.description,
                                price: result.price,
                                stock: result.stock
                            )
                        )
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
