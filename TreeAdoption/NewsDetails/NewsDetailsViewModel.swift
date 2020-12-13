import Combine
import Foundation

class NewsDetailsViewModel: ObservableObject {
    private let newsDetailsProvider: NewsDetailsProvider
    private let id: String
    private var bag = Set<AnyCancellable>()

    init(
        _ newsDetailsProvider: NewsDetailsProvider,
        _ id: String
    ) {
        self.newsDetailsProvider = newsDetailsProvider
        self.id = id
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<NewsItem> = .loading
}

extension NewsDetailsViewModel {
    func onAppear() {
        newsDetailsProvider.getNewsDetails(id: id)
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
