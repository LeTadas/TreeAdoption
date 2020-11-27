import Foundation

struct WebNewsResponse: Decodable {
    let id: String
    let contentId: String
    let createdAt: Date
    let contentType: Int
    let title: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case id
        case contentId
        case createdAt = "createdOn"
        case contentType
        case title
        case content = "text"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        contentId = try container.decode(String.self, forKey: .contentId)
        contentType = try container.decode(Int.self, forKey: .contentType)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)

        let dateString = try container.decode(String.self, forKey: .createdAt)

        if let localDateTime = DateFormatter.localDateTime.date(from: dateString) {
            createdAt = localDateTime
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .createdAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
    }
}
