import Combine

class AdoptTreeDetailsViewModel: ObservableObject {
    private let availableDetailsProvider: AvailableDetailsProvider
    private let productId: String
    private var bag = Set<AnyCancellable>()

    init(
        _ availableDetailsProvider: AvailableDetailsProvider,
        _ productId: String
    ) {
        self.availableDetailsProvider = availableDetailsProvider
        self.productId = productId
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<AdoptTreeDetails> = .loading
}

extension AdoptTreeDetailsViewModel {
    func adoptThisTreePressed() {}

    func onAppear() {
        availableDetailsProvider
            .getDetails(id: productId)
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

struct AdoptTreeDetails {
    let id: Int
    let name: String
    let description: String
    let price: Int
    let stock: Int
}
