import Combine
import Foundation

class WebUserService {
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
        let url = URL(string: "\(ApiConfig.url)/user/trees")

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
}
