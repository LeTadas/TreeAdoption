import Combine
import Foundation

class WebRefreshTokenService {
    func refreshToken() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        let url = URL(string: "\(ApiConfig.url)/auth/refreshToken")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebRefreshTokenService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getRefreshToken() else {
            fatalError("Refresh token token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"

        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .mapError { $0 as Error }
            .tryMap { response in

                if let error = NetworkErrorMapper.mapError(response: response.response) {
                    throw error
                }

                let value = try JSONDecoder().decode(RefreshTokenResponse.self, from: response.data)

                TokenArchiver.shared.storeAccessToken(token: value.accessToken)
                TokenArchiver.shared.storeRefreshToken(token: value.refreshToken)

                return response
            }
            .eraseToAnyPublisher()
    }
}
