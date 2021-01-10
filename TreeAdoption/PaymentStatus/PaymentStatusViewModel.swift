import Combine

class PaymentStatusViewModel: ObservableObject {
    private let webOrderServiceProvider: WebOrderServiceProvider
    private var bag = Set<AnyCancellable>()

    init(
        _ webOrderServiceProvider: WebOrderServiceProvider
    ) {
        self.webOrderServiceProvider = webOrderServiceProvider
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<PaymentResult> = .loading
}

extension PaymentStatusViewModel {
    func onAppear() {
        guard let id = OrderCache.shared.getOrderId() else {
            return
        }

        webOrderServiceProvider.getOrderStatus(id: id)
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        print("LOADED")
                        self.state = .loaded(result)
                    case let .failure(error):
                        print("Error: \(error)")
                        self.state = .error
                }
            }
            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}
