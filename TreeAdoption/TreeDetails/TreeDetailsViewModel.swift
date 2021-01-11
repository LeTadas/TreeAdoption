import Combine
import Foundation
import MapKit

class TreeDetailsViewModel: ObservableObject {
    private let treeId: Int
    private let defaultTreeDetailsProvider: DefaultTreeDetailsProvider
    let treeName: String
    private var bag = Set<AnyCancellable>()

    init(
        _ treeId: Int,
        _ defaultTreeDetailsProvider: DefaultTreeDetailsProvider,
        _ treeName: String
    ) {
        self.treeId = treeId
        self.defaultTreeDetailsProvider = defaultTreeDetailsProvider
        self.treeName = treeName
    }

    deinit {
        bag.removeAll()
    }

    func setViews() {}

    @Published var sheetVisible: Bool = false

    @Published var treeRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 52.083690,
            longitude: 4.329780
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.2,
            longitudeDelta: 0.2
        )
    )

    var treePinLocation: [ViewOnMapMarker] = [
        ViewOnMapMarker(latitude: 52.083690, longitude: 4.329780)
    ]

    @Published var graphData = GraphData(
        dataPoints: [
            Point(x: 0, y: 0.1),
            Point(x: 0.33, y: 0.7),
            Point(x: 0.66, y: 0.4),
            Point(x: 1, y: 0.8)
        ],
        xLabels: [
            GraphLabel(label: "Sep", isCurrent: false),
            GraphLabel(label: "Oct", isCurrent: false),
            GraphLabel(label: "Nov", isCurrent: false),
            GraphLabel(label: "Dec", isCurrent: true)
        ],
        yLabels: [
            GraphAmount(amount: 0.1),
            GraphAmount(amount: 0.3),
            GraphAmount(amount: 0.4),
            GraphAmount(amount: 0.5)
        ]
    )

    @Published var state: ViewState<TreeDetails> = .loading
    @Published var sheetView: DetailsSheetView = .timeline
}

enum DetailsSheetView {
    case timeline
    case bookATour
    case viewMap
}

extension TreeDetailsViewModel {
    func showTimeline() {
        sheetView = .timeline
        sheetVisible = true
    }

    func showBookATour() {
        sheetView = .bookATour
        sheetVisible = true
    }

    func showMap() {
        sheetView = .viewMap
        sheetVisible = true
    }

    func onAppear() {
        defaultTreeDetailsProvider.getTreeDetails(treeId: treeId)
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

struct TreeDetails {
    let treeName: String
    let contractEndsAt: Date
    let treeImageUrls: [String]
    let animalsDetected: [Animal]
    let treeHealth: TreeHealth
    let humidity: Double
    let temperature: Double
}

struct GraphData {
    let dataPoints: [Point]
    let xLabels: [GraphLabel]
    let yLabels: [GraphAmount]
}

struct GraphAmount {
    let amount: Double
}

struct GraphLabel {
    let label: String
    let isCurrent: Bool
}

struct TreeLocation: Identifiable {
    let id = UUID()
    let location: CLLocationCoordinate2D
}

struct TreeHealth {
    let condition: String
    let severityFraction: Double
    let updatedAt: Date
}

struct Animal {
    let type: Int
}
