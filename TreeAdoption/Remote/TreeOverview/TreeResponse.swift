import Foundation

struct TreeResponse: Decodable {
    let id: Int
    let forestId: Int
    let productId: Int
    let health: Int
    let latitude: String
    let longitude: String
    let plantedAt: Date
    let assignedTree: AssignedTreeResponse

    enum CodingKeys: String, CodingKey {
        case id
        case forestId
        case productId
        case health
        case latitude
        case longitude
        case plantedAt = "dateSeeded"
        case assignedTree
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        forestId = try container.decode(Int.self, forKey: .forestId)
        productId = try container.decode(Int.self, forKey: .productId)
        health = try container.decode(Int.self, forKey: .health)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        assignedTree = try container.decode(AssignedTreeResponse.self, forKey: .assignedTree)

        let dateString = try container.decode(String.self, forKey: .plantedAt)

        if let localDateTime = DateFormatter.localDateTime.date(from: dateString) {
            plantedAt = localDateTime
        } else {
            if let localDateTimeNoMillis = DateFormatter.localDateNoMillisTime.date(from: dateString) {
                plantedAt = localDateTimeNoMillis
            } else {
                if let localDateTimeNoZero = DateFormatter.localDateTimeNoZero.date(from: dateString) {
                    plantedAt = localDateTimeNoZero
                } else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .plantedAt,
                        in: container,
                        debugDescription: "Date string does not match format expected by formatter."
                    )
                }
            }
        }
    }
}

struct AssignedTreeResponse: Decodable {
    let userId: Int
    let treeId: Int
    let orderId: Int
    let createdAt: Date
    let expireAt: Date
    let name: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case treeId = "tree_id"
        case orderId = "order_id"
        case createdAt = "created_at"
        case expireAt = "expire_date"
        case name = "tree_name"
        case color = "tree_color"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userId = try container.decode(Int.self, forKey: .userId)
        treeId = try container.decode(Int.self, forKey: .treeId)
        orderId = try container.decode(Int.self, forKey: .orderId)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)

        let createdAtDateString = try container.decode(String.self, forKey: .createdAt)

        if let createdAtLocalDateTime = DateFormatter.localDateTime.date(from: createdAtDateString) {
            createdAt = createdAtLocalDateTime
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .createdAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }

        let expireAtDateString = try container.decode(String.self, forKey: .expireAt)

        if let expireAtLocalDateTime = DateFormatter.localDateTime.date(from: expireAtDateString) {
            expireAt = expireAtLocalDateTime
        } else {
            if let localDateTimeNoMillis = DateFormatter.localDateNoMillisTime.date(from: expireAtDateString) {
                expireAt = localDateTimeNoMillis
            } else {
                if let localDateTimeNoZero = DateFormatter.localDateTimeNoZero.date(from: expireAtDateString) {
                    expireAt = localDateTimeNoZero
                } else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .expireAt,
                        in: container,
                        debugDescription: "Date string does not match format expected by formatter."
                    )
                }
            }
        }
    }
}
