import Combine
import Foundation

protocol TelemetryProvider {
    func getTreeTelemetries() -> AnyPublisher<Result<[TelemetryResponse], RequestError>, Never>
}

class DefaultTelemetryProvider: TelemetryProvider {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func getTreeTelemetries() -> AnyPublisher<Result<[TelemetryResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/telemetry")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTelemetryProvider")
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
