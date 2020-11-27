import Combine
import Foundation

protocol AvailableTreesForAdoptionProvider {
    func getAvailableTrees() -> AnyPublisher<Result<[AdoptTreeItem], RequestError>, Never>
}

class DefaultAvailableTreesForAdoptionProvider: AvailableTreesForAdoptionProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getAvailableTrees() -> AnyPublisher<Result<[AdoptTreeItem], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/product")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTreeOverviewProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
            .map { (value: Result<[WebAdoptTreeResponse], RequestError>) in
                switch value {
                    case let .success(result):
                        let items = result.filter { $0.categoryId == 1 || $0.categoryId == 2 }
                        return .success(
                            items.map {
                                AdoptTreeItem(
                                    id: $0.id,
                                    name: $0.name,
                                    category: $0.categoryId,
                                    description: $0.description,
                                    price: $0.price,
                                    stock: $0.stock
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
