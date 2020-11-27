import Combine

class AdoptTreeViewModel: ObservableObject {
    @Published var state: AdoptTreeState = .loading
}

enum AdoptTreeState {
    case loading
    case loaded([AdoptTreeItem])
    case error
}

struct AdoptTreeItem {
    let id: String
    let name: String
    let description: String
    let price: Int
    let stock: Int
}
