import Combine
import Foundation

class WebBookTourService {
    private let networkClient: NetworkClient
    private let tokenArchiver: TokenArchiver
    private let userPersister: UserPersister

    init(_ networkClient: NetworkClient) {
        self.networkClient = networkClient
        tokenArchiver = TokenArchiver()
        userPersister = UserPersister()
    }

    func bookATour(tourId: Int) -> AnyPublisher<Result<BookTourResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/bookedtour")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebBookTourService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = tokenArchiver.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        guard let user = userPersister.getUser() else {
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

        return networkClient.execute(url: urlRequest)
    }
}
