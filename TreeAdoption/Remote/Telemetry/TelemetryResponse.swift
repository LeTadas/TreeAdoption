import Foundation

struct TelemetryResponse: Decodable {
    let id: String
    let treeId: String
    let reports: [ReportResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case treeId
        case reports
    }
}

struct ReportResponse: Decodable {
    let reportedOn: Date
    let temperature: Double
    let humidity: Double
    let treeLength: Double
    let treeDiameter: Double

    enum CodingKeys: String, CodingKey {
        case reportedOn
        case temperature
        case humidity
        case treeLength
        case treeDiameter
    }
}
