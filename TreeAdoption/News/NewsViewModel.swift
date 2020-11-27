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

    @Published var newsState: NewsState = .loading
}

extension NewsViewModel {
    func onAppear() {
        newsProvider.getNews()
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        if result.isEmpty {
                            self.newsState = .empty
                        } else {
                            self.newsState = .loaded(result)
                        }
                    case let .failure(error):
                        print("Network error: \(error.localizedDescription)")
                        self.newsState = .error
                }
            }
            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}

enum NewsState {
    case loading
    case loaded([NewsItem])
    case error
    case empty
}

struct NewsItem {
    let id: String
    let createdAt: Date
    let title: String
    let content: String
}
