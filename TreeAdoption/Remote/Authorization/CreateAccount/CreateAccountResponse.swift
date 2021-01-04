import Foundation

struct CreateAccountResponse: Decodable {
    let id: Int
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let password: String
    let salt: String
    let forgetToken: String
    let role: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case firstname
        case lastname
        case username
        case email
        case password
        case salt
        case forgetToken
        case role
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        salt = try container.decode(String.self, forKey: .salt)
        forgetToken = try container.decode(String.self, forKey: .forgetToken)
        role = try container.decode(Int.self, forKey: .role)

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
