import Combine
import Foundation

class PersonalizeTreeViewModel: ObservableObject {
    private let createOrderInteractor: CreateOrderInteractor
    private var orderCancelable: AnyCancellable?
    private let productId: String

    init(
        _ createOrderInteractor: CreateOrderInteractor,
        _ productId: String
    ) {
        self.createOrderInteractor = createOrderInteractor
        self.productId = productId
    }

    @Published var addPersonalSign: Bool = false
    @Published var treeName: String = "" {
        didSet {
            updateButton()
        }
    }

    @Published var signTitle: String = ""
    @Published var continueDisabled: Bool = true
    @Published var showPayment: Bool = false

    var paymentLink: String = "https://www.google.com/"

    func updateButton() {
        continueDisabled = treeName.isEmpty
    }
}

extension PersonalizeTreeViewModel {
    func adoptThisTreePressed() {
        guard let id = Int(productId) else {
            return
        }

        orderCancelable = createOrderInteractor
            .createOrder(userId: 1, productId: id)
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        self.paymentLink = result.paymentLink
                        self.showPayment = true
                    case let .failure(error):
                        print("Error: \(error.localizedDescription)")
                }
            }
    }
}
