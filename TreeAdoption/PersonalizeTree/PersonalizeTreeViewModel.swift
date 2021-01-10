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

    var paymentLink: String = ""

    func updateButton() {
        continueDisabled = treeName.isEmpty
    }
}

extension PersonalizeTreeViewModel {
    func adoptThisTreePressed(success: @escaping (String) -> Void) {
        guard let id = Int(productId) else {
            return
        }

        guard let user = UserPersister.shared.getUser() else {
            return
        }

        orderCancelable = createOrderInteractor
            .createOrder(userId: user.id, productId: id)
            .sink { value in
                switch value {
                    case let .success(result):
                        OrderCache.shared.storeOrderId(id: result.id)
                        success(result.paymentLink)
                    case let .failure(error):
                        print("Error: \(error.localizedDescription)")
                }
            }
    }
}
