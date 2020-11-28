import Combine

class AdoptTreeDetailsViewModel: ObservableObject {
    @Published var state: ViewState<AdoptTreeDetails> = .loading
}

extension AdoptTreeDetailsViewModel {
    func adoptThisTreePressed() {}
}

struct AdoptTreeDetails {
    let id: Int
    let name: String
    let description: String
    let price: Int
    let stock: Int
}
