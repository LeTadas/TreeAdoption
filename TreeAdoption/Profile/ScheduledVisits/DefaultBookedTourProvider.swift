import Combine

protocol BookedTourProvider {
    func getBookedTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never>
}

class DefaultBookedTourProvider: BookedTourProvider {
    private let webUserService: WebUserService
    private let webTourService: WebTourService
    private let webForestService: WebForestService

    init(
        _ webUserService: WebUserService,
        _ webTourService: WebTourService,
        _ webForestService: WebForestService
    ) {
        self.webUserService = webUserService
        self.webTourService = webTourService
        self.webForestService = webForestService
    }

    func getBookedTours() -> AnyPublisher<Result<[VisitItem], RequestError>, Never> {
        return webUserService.getBookedTours()
            .flatMap { [unowned self] value -> AnyPublisher<Result<[VisitItem], RequestError>, Never> in
                switch value {
                    case let .success(result):
                        return self.getAvailableTours(bookedTours: result)
                    case let .failure(error):
                        return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func getAvailableTours(bookedTours: [BookTourResponse]) -> AnyPublisher<Result<[VisitItem], RequestError>, Never> {
        return webTourService.getAvailableTours()
            .flatMap { [unowned self] value -> AnyPublisher<Result<[VisitItem], RequestError>, Never> in
                switch value {
                    case let .success(result):
                        return self.getAvailableForests(bookedTours: bookedTours, availableTours: result)
                    case let .failure(error):
                        return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func getAvailableForests(
        bookedTours: [BookTourResponse],
        availableTours: [WebTourResponse]
    ) -> AnyPublisher<Result<[VisitItem], RequestError>, Never> {
        return webForestService.getAvailableForests()
            .map { [unowned self] value -> Result<[VisitItem], RequestError> in
                switch value {
                    case let .success(result):
                        return .success(
                            self.mapResults(
                                bookedTours: bookedTours,
                                availableTours: availableTours,
                                availableForests: result
                            )
                        )
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    private func mapResults(
        bookedTours: [BookTourResponse],
        availableTours: [WebTourResponse],
        availableForests: [WebForestResponse]
    ) -> [VisitItem] {
        let tourIds = bookedTours.map { $0.tourId }
        let filteredTours = availableTours.filter { tourIds.contains($0.id) }

        return filteredTours.map { tour in
            let forest = availableForests.filter { $0.id == tour.forestId }.first!
            return VisitItem(
                id: tour.id,
                title: "Guided Tour (\(tour.language))",
                latitude: forest.latitude,
                longitude: forest.longitude,
                date: tour.dateTime,
                description: tour.description
            )
        }
    }
}
