import Combine
import MapKit

protocol TourProvider {
    func getAvailableTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never>
}

class DefaultTourProvider: TourProvider {
    private let webTourService: WebTourService

    init(_ webTourService: WebTourService) {
        self.webTourService = webTourService
    }

    func getAvailableTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never> {
        return webTourService.getAvailableTours()
            .map { (value: Result<[WebTourResponse], RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(
                            result.map {
                                VisitItem(
                                    id: $0.id,
                                    title: "Guided Tour (\($0.language))",
                                    latitude: 0,
                                    longitude: 0,
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
