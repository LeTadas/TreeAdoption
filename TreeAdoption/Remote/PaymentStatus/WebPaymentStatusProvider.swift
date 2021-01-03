import Combine
import Foundation

protocol PaymentStatusProvider {
    func getOrderStatus(id: Int) -> AnyPublisher<Result<PaymentResult, RequestError>, Never>
}

class WebPaymentStatusProvider: PaymentStatusProvider {
    private let networkClient: NetworkClient

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getOrderStatus(id: Int) -> AnyPublisher<Result<PaymentResult, RequestError>, Never> {
        var url = URL(string: "\(ApiConfig.url)/order")
        url?.appendPathComponent(String(id), isDirectory: false)

        guard let requestUrl = url else {
            fatalError("Could not parse url WebPaymentStatusProvider")
        }

        let urlRequest = URLRequest(url: requestUrl)

        return networkClient.execute(url: urlRequest)
            .map { [unowned self] (value: Result<WebPaymentStatusResponse, RequestError>) in
                switch value {
                    case let .success(result):
                        return .success(self.mapStatus(response: result))
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    private func mapStatus(response: WebPaymentStatusResponse) -> PaymentResult {
        if response.paymentStatus == "paid" {
            return .paid
        } else {
            return .failed
        }
    }
}
