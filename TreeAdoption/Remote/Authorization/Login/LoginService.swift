import Combine
import Foundation

class LoginService {
    func login(username: String, password: String) -> AnyPublisher<Result<LoginResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/auth/login")

        guard let requestUrl = url else {
            fatalError("Could not parse url LoginService")
        }

        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"

        let request = LoginRequest(
            username: username,
            password: password
        )
        guard let jsonData = try? JSONEncoder().encode(request) else {
            fatalError("Could not serialize json body LoginService")
        }

        urlRequest.httpBody = jsonData

        return NetworkClient.shared.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }
}
