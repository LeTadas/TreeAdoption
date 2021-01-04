import Combine
import Foundation

class NetworkClient {
    func execute<T: Decodable>(url: URLRequest) -> AnyPublisher<Result<T, RequestError>, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard
                    let httpResponse = element.response as? HTTPURLResponse,
                    (200 ... 300).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map {
                .success($0)
            }
            .catch { error -> Just<Result<T, RequestError>> in
                if let urlError = error as? URLError {
                    print("NetworkClient URL ERROR")
                    return Just(.failure(RequestError.urlError(urlError)))
                } else if let decodingError = error as? DecodingError {
                    print("NetworkClient DECODING ERROR: \(decodingError.localizedDescription)")
                    return Just(.failure(RequestError.decodingError(decodingError)))
                } else {
                    print("NetworkClient ERROR")
                    return Just(.failure(RequestError.genericError(error)))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
