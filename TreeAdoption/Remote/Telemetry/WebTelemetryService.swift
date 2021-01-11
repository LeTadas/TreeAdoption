import Combine
import Foundation

class WebTelemetryService {
    func getTreeTelemetries() -> AnyPublisher<Result<[TelemetryResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/telemetry")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTelemetryProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }

    func getTreeTelemetry(treeId: Int) -> AnyPublisher<Result<TelemetryResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/telemetry/\(treeId)")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTelemetryProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }
}
