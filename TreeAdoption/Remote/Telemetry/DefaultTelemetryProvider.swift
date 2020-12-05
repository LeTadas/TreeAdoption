import Combine
import Foundation

protocol TelemetryProvider {
    func getTreeTelemetries() -> AnyPublisher<Result<[TelemetryResponse], RequestError>, Never>
}

class DefaultTelemetryProvider: TelemetryProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getTreeTelemetries() -> AnyPublisher<Result<[TelemetryResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/telemetry")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTelemetryProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }
}
