import Combine
import Foundation
import MapKit

class FakeTourProvider: TourProvider {
    func getAvailableTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never> {
        return Just(
            Result.success(
                [
                    VisitItem(
                        id: 0,
                        title: "Guided visit (English)",
                        location: CLLocationCoordinate2D(
                            latitude: 52.083690,
                            longitude: 4.329780
                        ),
                        date: Date(),
                        description:
                        """
                        Tour Guides accompany tourists visiting unfamiliar areas. A good Tour Guide sample resume mentions duties like performing research, organising trips, offering information and advice about touristic destinations, making travel arrangements, and translating or interpreting. Tour Guides should also solve tourist queries and problems.
                        """
                    ),
                    VisitItem(
                        id: 1,
                        title: "Guided visit (English)",
                        location: CLLocationCoordinate2D(
                            latitude: 52.083690,
                            longitude: 4.329780
                        ),
                        date: Date(),
                        description:
                        """
                        Tour Guides accompany tourists visiting unfamiliar areas. A good Tour Guide sample resume mentions duties like performing research, organising trips, offering information and advice about touristic destinations, making travel arrangements, and translating or interpreting. Tour Guides should also solve tourist queries and problems.
                        """
                    )
                ]
            )
        )
        .eraseToAnyPublisher()
    }
}
