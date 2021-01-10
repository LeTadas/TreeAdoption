import Combine
import Foundation
import MapKit

class WebTourService {
    func getAvailableTours() -> AnyPublisher<Result<[WebTourResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/tour")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTourProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
    }
}
