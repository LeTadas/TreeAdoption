import Combine
import Foundation

protocol TreeOverviewProvider {
    func getTreeOverview() -> AnyPublisher<Result<[TreeResponse], RequestError>, Never>
}

class DefaultTreeOverviewProvider: TreeOverviewProvider {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func getTreeOverview() -> AnyPublisher<Result<[TreeResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/tree")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTreeOverviewProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return networkClient.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }
}
