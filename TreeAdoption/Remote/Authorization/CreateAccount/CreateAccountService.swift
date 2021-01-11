import Combine
import Foundation

class CreateAccountService {
    func register(
        _ registerInfo: RegisterInfo
    ) -> AnyPublisher<Result<CreateAccountResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/auth/register")

        guard let requestUrl = url else {
            fatalError("Could not parse url CreateAccountService")
        }

        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"

        let request = CreateAccountRequest(
            firstname: registerInfo.firstName,
            lastname: registerInfo.lastName,
            username: registerInfo.userName,
            email: registerInfo.email,
            password: registerInfo.password
        )
        guard let jsonData = try? JSONEncoder().encode(request) else {
            fatalError("Could not serialize json body CreateAccountService")
        }

        urlRequest.httpBody = jsonData

        return NetworkClient.shared.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }
}
