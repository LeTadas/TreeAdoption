import Combine
import MapKit

class MyVisitsViewModel: ObservableObject {
    private let bookedTourProvider: BookedTourProvider
    private let webBookTourService: WebBookTourService
    private var bag = Set<AnyCancellable>()
    private var cancelTourCancellable: AnyCancellable?

    init(
        _ bookedTourProvider: BookedTourProvider,
        _ webBookTourService: WebBookTourService
    ) {
        self.bookedTourProvider = bookedTourProvider
        self.webBookTourService = webBookTourService
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<[VisitItem]> = .loaded(
        [
            VisitItem(
                id: 0,
                title: "Guided visit",
                latitude: 52.083690,
                longitude: 4.329780,
                date: Date(),
                description:
                """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dignissim sapien a odio varius volutpat. Donec aliquet imperdiet sagittis. Suspendisse potenti. Etiam eu magna massa. Quisque eleifend sollicitudin risus, id feugiat urna.
                """
            ),

            VisitItem(
                id: 1,
                title: "Guided visit",
                latitude: 52.083690,
                longitude: 4.329780,
                date: Date(),
                description:
                """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dignissim sapien a odio varius volutpat. Donec aliquet imperdiet sagittis. Suspendisse potenti. Etiam eu magna massa. Quisque eleifend sollicitudin risus, id feugiat urna.
                """
            )
        ]
    )

    @Published var viewOnMapVisible: Bool = false
    var viewOnMapMarker: ViewOnMapMarker?

    @Published var alertVisible: Bool = false
    var tourId: Int?
}

extension MyVisitsViewModel {
    func onCancelApproved() {
        guard let id = tourId else {
            return
        }

        cancelTourCancellable = webBookTourService.cancelTour(tourId: id)
            .sink { [unowned self] value in
                switch value {
                    case .success:
                        print("Success")
                    case .failure:
                        print("Error")
                }
                self.cancelTourCancellable = nil
            }
    }

    func onCancelDismissed() {
        tourId = nil
    }

    func cancelPressed(tourId: Int) {
        self.tourId = tourId
        alertVisible = true
    }

    func viewOnMapPressed(_ marker: ViewOnMapMarker) {
        viewOnMapMarker = marker
        viewOnMapVisible = true
    }

    func onAppear() {
//        bookedTourProvider.getBookedTours()
//            .sink { [unowned self] value in
//                switch value {
//                    case let .success(result):
//                        self.state = .loaded(result)
//                    case .failure:
//                        self.state = .error
//                }
//            }
//            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}
