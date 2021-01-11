import Combine
import Foundation

class WebUserService {
    func updateEmail(email: String) -> AnyPublisher<Result<Void, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/user")

        guard let requestUrl = url else {
            fatalError("Could not parse url LoginService")
        }

        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "PUT"

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let request = UpdateEmailRequest(email: email)

        guard let jsonData = try? JSONEncoder().encode(request) else {
            fatalError("Could not serialize json body CreateAccountService")
        }

        urlRequest.httpBody = jsonData

        return NetworkClient.shared.execute(url: urlRequest)
            .map { (value: Result<EmptyResponse, RequestError>) in
                switch value {
                    case .success:
                        return .success(())
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    func getDetails(token: String) -> AnyPublisher<Result<UserDetailsResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/loggedinuser")

        guard let requestUrl = url else {
            fatalError("Could not parse url LoginService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
            .eraseToAnyPublisher()
    }

    func getBookedTours() -> AnyPublisher<Result<[BookTourResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/user/bookedtours")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebUserBookedVisitsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return NetworkClient.shared.execute(url: urlRequest)
    }

    func getAdoptedTrees() -> AnyPublisher<Result<[TreeResponse], RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/tree")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebUserBookedVisitsProvider")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            return Just(Result.failure(RequestError.genericError(NSError()))).eraseToAnyPublisher()
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return NetworkClient.shared.execute(url: urlRequest)
    }
}
