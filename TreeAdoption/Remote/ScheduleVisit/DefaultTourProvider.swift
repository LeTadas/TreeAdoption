import Combine
import Foundation
import MapKit

protocol TourProvider {
    func getAvailableTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never>
}

class DefaultTourProvider: TourProvider {
    private let networkClient: NetworkClient

    init(
        _ networkClient: NetworkClient
    ) {
        self.networkClient = networkClient
    }

    func getAvailableTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/tour")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultTourProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
            .map { (value: Result<[WebTourResponse], RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(
                            result.map {
                                VisitItem(
                                    id: $0.id,
                                    title: "Guided visit (\($0.language))",
                                    location: CLLocationCoordinate2D(
                                        latitude: 52.132633,
                                        longitude: 5.291266
                                    ),
                                    date: $0.dateTime,
                                    description: $0.description
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
