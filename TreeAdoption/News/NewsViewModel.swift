import Combine
import Foundation

class NewsViewModel: ObservableObject {
    @Published var newsState: NewsState = .error
}

enum NewsState {
    case loading
    case loaded([NewsItem])
    case error
    case empty
}

struct NewsItem {
    let id: Int
    let createdAt: Date
    let title: String
    let content: String
}
