import Combine
import Foundation

class WebBookTourService {
    func bookATour(tourId: Int) -> AnyPublisher<Result<BookTourResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/bookedtour")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebBookTourService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        guard let user = UserPersister.shared.getUser() else {
            fatalError("User is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"

        let request = BookTourRequest(
            tourId: tourId,
            userId: user.id,
            userName: user.firstName,
            userEmail: user.email,
            bookedDateTime: DateFormatter.localDateTime.string(from: Date())
        )

        guard let jsonData = try? JSONEncoder().encode(request) else {
            fatalError("Could not serialize json body WebBookTourService")
        }

        urlRequest.httpBody = jsonData

        return NetworkClient.shared.execute(url: urlRequest)
    }

    func cancelTour(bookedTourId: Int) -> AnyPublisher<Result<Void, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/bookedtour/\(bookedTourId)")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebBookTourService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "DELETE"

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
}
