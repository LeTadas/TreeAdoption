import Combine

class DefaultMyTreeProvider {
    private let webUserService: WebUserService
    private let webTelemetryService: WebTelemetryService

    init(
        _ webUserService: WebUserService,
        _ webTelemetryService: WebTelemetryService
    ) {
        self.webUserService = webUserService
        self.webTelemetryService = webTelemetryService
    }

    func getAdoptedTrees() -> AnyPublisher<Result<[TreeSummary], RequestError>, Never> {
        return webUserService.getAdoptedTrees()
            .flatMap { [unowned self] (value: Result<[TreeResponse], RequestError>) -> AnyPublisher<Result<[TreeSummary], RequestError>, Never> in
                switch value {
                    case let .success(result):
                        return self.getTelemetries(treeResponse: result)
                    case let .failure(error):
                        return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func getTelemetries(treeResponse: [TreeResponse]) -> AnyPublisher<Result<[TreeSummary], RequestError>, Never> {
        return webTelemetryService.getTreeTelemetries()
            .map { [unowned self] (value: Result<[TelemetryResponse], RequestError>) -> Result<[TreeSummary], RequestError> in
                switch value {
                    case let .success(result):
                        return .success(self.mapResults(treeResponse: treeResponse, telemetries: result))
                    case let .failure(error):
                        return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    private func mapResults(treeResponse: [TreeResponse], telemetries: [TelemetryResponse]) -> [TreeSummary] {
        let summaries = treeResponse.map { treeOverview -> TreeSummary in
            let treeTelemetry = telemetries.filter { $0.treeId == String(treeOverview.id) }.first

            guard let telemetry = treeTelemetry else {
                return TreeSummary(
                    id: treeOverview.id,
                    name: treeOverview.assignedTree.name,
                    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg",
                    humidity: 0,
                    temperature: 0,
                    length: 0
                )
            }

            let reports = telemetry.reports.sorted(by: { $0.reportedOn.timeIntervalSince1970 > $1.reportedOn.timeIntervalSince1970 })

            guard let latestReport = reports.first else {
                return TreeSummary(
                    id: treeOverview.id,
                    name: treeOverview.assignedTree.name,
                    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg",
                    humidity: 0,
                    temperature: 0,
                    length: 0
                )
            }

            return TreeSummary(
                id: treeOverview.id,
                name: treeOverview.assignedTree.name,
                imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Joshua_Tree_01.jpg/1200px-Joshua_Tree_01.jpg",
                humidity: latestReport.humidity,
                temperature: latestReport.temperature,
                length: latestReport.treeLength
            )
        }

        return summaries
    }
}
