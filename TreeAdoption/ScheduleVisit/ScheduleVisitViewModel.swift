import Combine
import Foundation
import MapKit

class ScheduleVisitViewModel: ObservableObject {
    private let tourProvider: TourProvider
    private var bag = Set<AnyCancellable>()

    init(_ tourProvider: TourProvider) {
        self.tourProvider = tourProvider
    }

    deinit {
        bag.removeAll()
    }

    @Published var selectedVisit = VisitItem(
        id: -1,
        title: "",
        location: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        date: Date(),
        description: ""
    ) {
        didSet {
            updateButton()
        }
    }

    @Published var state: ViewState<[VisitItem]> = .loading

    @Published var scheduleButtonsDisabled: Bool = true

    private func updateButton() {
        if selectedVisit.id == -1 {
            scheduleButtonsDisabled = true
            return
        }

        scheduleButtonsDisabled = false
    }
}

extension ScheduleVisitViewModel {
    func scheduleVisit() {
        if selectedVisit.id == -1 {
            return
        }
    }

    func onAppear() {
        tourProvider.getAvailableTours()
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        self.state = .loaded(result)
                    case .failure:
                        self.state = .error
                }
            }
            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}

struct VisitItem: Equatable {
    let id: Int
    let title: String
    let location: CLLocationCoordinate2D
    let date: Date
    let description: String

    static func == (lhs: VisitItem, rhs: VisitItem) -> Bool {
        return lhs.id == rhs.id
    }
}
