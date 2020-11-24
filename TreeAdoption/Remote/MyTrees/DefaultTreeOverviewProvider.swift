import Combine
import Foundation

protocol TreeOverviewProvider {
    func getTreeOverview() -> AnyPublisher<Result<[TreeResponse], RequestError>, Never>
}

class DefaultTreeOverviewProvider: TreeOverviewProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getTreeOverview() -> AnyPublisher<Result<[TreeResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/tree")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTreeOverviewProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest).eraseToAnyPublisher()
    }
}
