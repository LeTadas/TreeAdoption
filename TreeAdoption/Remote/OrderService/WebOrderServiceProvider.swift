import Combine
import Foundation

class WebOrderServiceProvider {
    func getOrderStatus(id: Int) -> AnyPublisher<Result<PaymentResult, RequestError>, Never> {
        var url = URL(string: "\(ApiConfig.url)/order")
        url?.appendPathComponent(String(id), isDirectory: false)

        guard let requestUrl = url else {
            fatalError("Could not parse url WebPaymentStatusProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
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
