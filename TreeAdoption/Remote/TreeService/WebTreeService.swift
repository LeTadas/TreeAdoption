import Combine
import Foundation

class WebTreeService {
    func getTreeDetails(treeId: Int) -> AnyPublisher<Result<TreeResponse, RequestError>, Never> {
        let url = URL(string: "\(ApiConfig.url)/tree/\(treeId)")

        guard let requestUrl = url else {
            fatalError("Could not parse url WebTreeService")
        }

        var urlRequest = URLRequest(url: requestUrl)

        guard let token = TokenArchiver.shared.getAccessToken() else {
            fatalError("Auth token is nil")
        }

        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return NetworkClient.shared.execute(url: urlRequest)
    }
}
