import Combine
import Foundation

class ScheduleVisitViewModel: ObservableObject {
    private let tourProvider: TourProvider
    private let webBookTourService: WebBookTourService
    private var bag = Set<AnyCancellable>()
    private var bookATourCancellable: AnyCancellable?

    init(
        _ tourProvider: TourProvider,
        _ webBookTourService: WebBookTourService
    ) {
        self.tourProvider = tourProvider
        self.webBookTourService = webBookTourService
    }

    deinit {
        bag.removeAll()
    }

    @Published var selectedVisit = VisitItem(
        id: -1,
        title: "",
        latitude: 0,
        longitude: 0,
        date: Date(),
        description: ""
    ) {
        didSet {
            updateButton()
        }
    }

    @Published var state: ViewState<[VisitItem]> = .loading

    @Published var scheduleButtonsDisabled: Bool = true
    @Published var successVisible: Bool = false

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

        bookATourCancellable = webBookTourService.bookATour(tourId: selectedVisit.id)
            .sink { [unowned self] value in
                switch value {
                    case .success:
                        self.successVisible = true
                    case .failure:
                        break
                }
                self.bookATourCancellable = nil
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
    let latitude: Double
    let longitude: Double
    let date: Date
    let description: String

    static func == (lhs: VisitItem, rhs: VisitItem) -> Bool {
        return lhs.id == rhs.id
    }
}
