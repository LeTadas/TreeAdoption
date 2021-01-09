import Combine
import Foundation

protocol CreateOrderInteractor {
    func createOrder(userId: Int, productId: Int) -> AnyPublisher<Result<WebCreateOrderResponse, RequestError>, Never>
}

class DefaultCreateOrderInteractor: CreateOrderInteractor {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
    }

    func createOrder(userId: Int, productId: Int) -> AnyPublisher<Result<WebCreateOrderResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/order")

        guard let requestUrl = url else {
            fatalError("Could not parse url DefaultAvailableDetailsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"

        let newOrder = NewOrderRequest(
            userId: userId,
            paymentRedirectLink: "mollie-app://payment-return",
            orderLines: [
                OrderLine(
                    productId: productId,
                    quantity: 1
                )
            ]
        )

        guard let jsonData = try? JSONEncoder().encode(newOrder) else {
            fatalError("Could not serialize json body DefaultCreateOrderInteractor")
        }

        urlRequest.httpBody = jsonData

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return networkClient.execute(url: urlRequest)
    }
}
