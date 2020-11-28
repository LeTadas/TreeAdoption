import Combine
import Foundation

class NewsViewModel: ObservableObject {
    private let newsProvider: NewsProvider
    private var bag = Set<AnyCancellable>()

    init(_ newsProvider: NewsProvider) {
        self.newsProvider = newsProvider
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<[NewsItem]> = .loading
}

extension NewsViewModel {
    func onAppear() {
        newsProvider.getNews()
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        self.state = .loaded(result)
                    case let .failure(error):
                        print("Network error: \(error.localizedDescription)")
                        self.state = .error
                }
            }
            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}

struct NewsItem {
    let id: String
    let createdAt: Date
    let title: String
    let content: String
}
