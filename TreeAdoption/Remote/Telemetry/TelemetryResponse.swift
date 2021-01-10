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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        temperature = try container.decode(Double.self, forKey: .temperature)
        humidity = try container.decode(Double.self, forKey: .humidity)
        treeLength = try container.decode(Double.self, forKey: .treeLength)
        treeDiameter = try container.decode(Double.self, forKey: .treeDiameter)

        let dateString = try container.decode(String.self, forKey: .reportedOn)

        if let localDateTime = DateFormatter.localDateTime.date(from: dateString) {
            reportedOn = localDateTime
        } else {
            if let localDateTimeNoMillis = DateFormatter.localDateNoMillisTime.date(from: dateString) {
                reportedOn = localDateTimeNoMillis
            } else {
                if let localDateTimeNoZero = DateFormatter.localDateTimeNoZero.date(from: dateString) {
                    reportedOn = localDateTimeNoZero
                } else {
                    if let zoneDateTimeNoZero = DateFormatter.zoneDateTime.date(from: dateString) {
                        reportedOn = zoneDateTimeNoZero
                    } else {
                        throw DecodingError.dataCorruptedError(
                            forKey: .reportedOn,
                            in: container,
                            debugDescription: "Date string does not match format expected by formatter."
                        )
                    }
                }
            }
        }
    }
}
