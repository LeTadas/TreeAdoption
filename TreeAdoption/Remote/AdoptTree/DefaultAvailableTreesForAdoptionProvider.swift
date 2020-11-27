import Combine
import Foundation

protocol AvailableTreesForAdoptionProvider {
	func getAvailableTrees() -> AnyPublisher<Result<[WebAdoptTreeResponse], RequestError>, Never>
}

class DefaultAvailableTreesForAdoptionProvider: AvailableTreesForAdoptionProvider {

	private let networkClient: NetworkClient

	init(_ networkClient: NetworkClient) {
		self.networkClient = networkClient
	}

	func getAvailableTrees() -> AnyPublisher<Result<[WebAdoptTreeResponse], RequestError>, Never> {
		let url = URL(string: "\(ApiConfig.url)/product")

		guard let requestUrl = url else {
			fatalError("Could not parse url DefaultTreeOverviewProvider")
		}

		let urlRequest = URLRequest(url: requestUrl)

		return networkClient.execute(url: urlRequest).eraseToAnyPublisher()
	}
}
