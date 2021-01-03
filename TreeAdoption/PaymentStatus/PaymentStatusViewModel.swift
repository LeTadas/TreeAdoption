import Combine

class PaymentStatusViewModel: ObservableObject {
    private let paymentStatusProvider: PaymentStatusProvider
    private let id: Int
    private var bag = Set<AnyCancellable>()

    init(
        _ paymentStatusProvider: PaymentStatusProvider,
        _ id: Int
    ) {
        self.paymentStatusProvider = paymentStatusProvider
        self.id = id
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<PaymentResult> = .loading
}

extension PaymentStatusViewModel {
    func onAppear() {
        paymentStatusProvider.getOrderStatus(id: id)
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
