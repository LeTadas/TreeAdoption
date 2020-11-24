import Combine
import Foundation

class NetworkClient {
    func execute<T: Decodable>(url: URLRequest) -> AnyPublisher<Result<T, RequestError>, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
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
                    return Just(.failure(RequestError.urlError(urlError)))
                } else if let decodingError = error as? DecodingError {
                    return Just(.failure(RequestError.decodingError(decodingError)))
                } else {
                    return Just(.failure(RequestError.genericError(error)))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
