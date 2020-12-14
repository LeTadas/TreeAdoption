import Foundation

struct WebTourResponse: Decodable {
    let id: Int
    let description: String
    let dateTime: Date
    let forestId: Int
    let language: String

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case dateTime
        case forestId
        case language
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        forestId = try container.decode(Int.self, forKey: .forestId)
        language = try container.decode(String.self, forKey: .language)

        let dateString = try container.decode(String.self, forKey: .dateTime)

        if let localDateTime = DateFormatter.localDateTime.date(from: dateString) {
            dateTime = localDateTime
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .dateTime,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
    }
}
