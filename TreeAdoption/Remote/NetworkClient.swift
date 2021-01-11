import Combine
import Foundation

class NetworkClient {
    static let shared = NetworkClient(WebRefreshTokenService())

    private let webRefreshTokenService: WebRefreshTokenService

    init(_ webRefreshTokenService: WebRefreshTokenService) {
        self.webRefreshTokenService = webRefreshTokenService
    }

    func execute<T: Decodable>(url: URLRequest) -> AnyPublisher<Result<T, RequestError>, Never> {
        return refreshingRequest(url: url)
            .tryMap { (data: Data, response: URLResponse) -> Result<T, RequestError> in

                if let error = NetworkErrorMapper.mapError(response: response) {
                    throw error
                }

                let value = try JSONDecoder().decode(T.self, from: data)
                return .success(value)
            }
            .catch { error -> Just<Result<T, RequestError>> in
                if let urlError = error as? URLError {
                    print("NetworkClient URL ERROR")
                    return Just(.failure(RequestError.urlError(urlError)))
                } else if let decodingError = error as? DecodingError {
                    print("NetworkClient DECODING ERROR: \(decodingError.localizedDescription)")
                    return Just(.failure(RequestError.decodingError(decodingError)))
                } else if let networkError = error as? NetworkError {
                    print("NetworkClient NETWORK ERROR")
                    return Just(.failure(RequestError.networkError(networkError)))
                } else {
                    print("NetworkClient ERROR")
                    return Just(.failure(RequestError.genericError(error)))
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func refreshingRequest(url: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        return dataTaskPublisher(url: url)
            .tryCatch { [unowned self] error -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                switch error {
                    case NetworkError.unauthorised:
                        return webRefreshTokenService.refreshToken()
                            .flatMap { [unowned self] _ -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                                var authorizedRequest = url

                                if url.allHTTPHeaderFields?["Authorization"] != nil {
                                    authorizedRequest.allHTTPHeaderFields?["Authorization"] = nil
                                    authorizedRequest.setValue(nil, forHTTPHeaderField: "Authorization")
                                    let token = TokenArchiver.shared.getAccessToken()
                                    authorizedRequest.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
                                }

                                return self.dataTaskPublisher(url: authorizedRequest)
                                    .eraseToAnyPublisher()
                            }
                            .eraseToAnyPublisher()
                    default:
                        throw error
                }
            }
            .retry(0)
            .eraseToAnyPublisher()
    }

    private func dataTaskPublisher(url: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { response -> AnyPublisher<(data: Data, response: URLResponse), Error> in
                guard let error = NetworkErrorMapper.mapError(response: response.response) else {
                    return Just(response)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                if let networkError = error as? NetworkError, networkError == NetworkError.unauthorised {
                    return Fail(error: NetworkError.unauthorised)
                        .eraseToAnyPublisher()
                }

                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
