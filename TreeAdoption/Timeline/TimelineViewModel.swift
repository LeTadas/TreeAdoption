import Combine
import Foundation

class TimelineViewModel: ObservableObject {
    private let timelineProvider: TimelineProvider
    private var bag = Set<AnyCancellable>()

    init(_ timelineProvider: TimelineProvider) {
        self.timelineProvider = timelineProvider
    }

    @Published var state: ViewState<[TimelineItemType]> = .loading
}

extension TimelineViewModel {
    func onAppear() {
        timelineProvider.getTimeline()
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

enum TimelineItemType {
    case label(String)
    case image(TimelineImageItem)
    case health(TimelineHealthItem)
}

struct TimelineImageItem {
    let title: String
    let description: String
    let imageUrl: String
    let date: Date
}

struct TimelineHealthItem {
    let title: String
    let description: String
    let severityFraction: Double
    let date: Date
}
