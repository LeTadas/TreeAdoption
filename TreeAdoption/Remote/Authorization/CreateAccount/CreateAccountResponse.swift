import Foundation

struct CreateAccountResponse: Decodable {
    let id: Int
    let firstname: String
    let lastname: String
    let username: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstname
        case lastname
        case username
        case email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        firstname = try container.decode(String.self, forKey: .firstname)
        lastname = try container.decode(String.self, forKey: .lastname)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
    }
}
