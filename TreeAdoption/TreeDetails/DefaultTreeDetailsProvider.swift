import Combine
import Foundation

class DefaultTreeDetailsProvider {
    private let webTreeService: WebTreeService
    private let webTelemetryService: WebTelemetryService

    init(
        _ webTreeService: WebTreeService,
        _ webTelemetryService: WebTelemetryService
    ) {
        self.webTreeService = webTreeService
        self.webTelemetryService = webTelemetryService
    }

    func getTreeDetails(treeId: Int) -> AnyPublisher<Result<TreeDetails, RequestError>, Never> {
        return webTreeService.getTreeDetails(treeId: treeId)
            .flatMap { [unowned self] value -> AnyPublisher<Result<TreeDetails, RequestError>, Never> in
                switch value {
                    case let .success(result):
                        return self.getTreeTelemetry(
                            treeId: treeId,
                            treeResponse: result
                        )
                    case let .failure(error):
                        return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func getTreeTelemetry(
        treeId: Int,
        treeResponse: TreeResponse
    ) -> AnyPublisher<Result<TreeDetails, RequestError>, Never> {
        return webTelemetryService.getTreeTelemetry(treeId: treeId)
            .map { [unowned self] value -> Result<TreeDetails, RequestError> in
                switch value {
                    case let .success(result):
                        return .success(
                            self.mapResult(treeResponse: treeResponse, telemetryResponse: result)
                        )
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    private func mapResult(
        treeResponse: TreeResponse,
        telemetryResponse: TelemetryResponse
    ) -> TreeDetails {
        let reports = telemetryResponse.reports.sorted(
            by: { $0.reportedOn.timeIntervalSince1970 > $1.reportedOn.timeIntervalSince1970 }
        )
        let latest = reports.first!
        return TreeDetails(
            treeName: treeResponse.assignedTree.name,
            contractEndsAt: Date(),
            treeImageUrls: [
                "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg"
            ],
            animalsDetected: [
                Animal(type: 0),
                Animal(type: 1),
                Animal(type: 2),
                Animal(type: 3)
            ],
            treeHealth: TreeHealth(
                condition: "Oak Wilt",
                severityFraction: Double(treeResponse.health) / 100.0,
                updatedAt: Date()
            ),
            humidity: latest.humidity,
            temperature: latest.temperature
        )
    }
}
