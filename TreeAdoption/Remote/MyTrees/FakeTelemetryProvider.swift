import Combine
import Foundation

class FakeTelemetryProvider: TelemetryProvider {
    func getTreeTelemetries() -> AnyPublisher<Result<[TelemetryResponse], RequestError>, Never> {
        return Just(
            Result.success(
                [
                    TelemetryResponse(
                        id: "0",
                        treeId: "1",
                        reports: [
                            ReportResponse(
                                reportedOn: Date().advanced(by: 60),
                                temperature: 14.2,
                                humidity: 30.2,
                                treeLength: 120.1,
                                treeDiameter: 66
                            ),
                            ReportResponse(
                                reportedOn: Date().advanced(by: 20),
                                temperature: 13.5,
                                humidity: 44,
                                treeLength: 164.2,
                                treeDiameter: 20
                            )
                        ]
                    ),
                    TelemetryResponse(
                        id: "1",
                        treeId: "2",
                        reports: [
                            ReportResponse(
                                reportedOn: Date().advanced(by: 60),
                                temperature: 16.1,
                                humidity: 50.1,
                                treeLength: 220.92,
                                treeDiameter: 40
                            ),
                            ReportResponse(
                                reportedOn: Date().advanced(by: 20),
                                temperature: 13.5,
                                humidity: 44,
                                treeLength: 164.2,
                                treeDiameter: 20
                            )
                        ]
                    ),
                    TelemetryResponse(
                        id: "2",
                        treeId: "3",
                        reports: [
                            ReportResponse(
                                reportedOn: Date().advanced(by: 60),
                                temperature: 13.5,
                                humidity: 44,
                                treeLength: 164.2,
                                treeDiameter: 20
                            ),
                            ReportResponse(
                                reportedOn: Date().advanced(by: 20),
                                temperature: 13.5,
                                humidity: 44,
                                treeLength: 164.2,
                                treeDiameter: 20
                            )
                        ]
                    )
                ]
            )
        ).eraseToAnyPublisher()
    }
}
