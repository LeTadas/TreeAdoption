import Foundation

struct WebTourResponse: Decodable {
    let id: Int
    let description: String
    let dateTime: Date
    let forestId: Int
    let language: String
    let slots: Int
    let guideName: String
    let guideSpecialty: String

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case dateTime
        case forestId
        case language
        case slots
        case guideName
        case guideSpecialty
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        forestId = try container.decode(Int.self, forKey: .forestId)
        language = try container.decode(String.self, forKey: .language)
        slots = try container.decode(Int.self, forKey: .slots)
        guideName = try container.decode(String.self, forKey: .guideName)
        guideSpecialty = try container.decode(String.self, forKey: .guideSpecialty)

        let dateString = try container.decode(String.self, forKey: .dateTime)

        if let localDateTime = DateFormatter.localDateNoMillisTime.date(from: dateString) {
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
