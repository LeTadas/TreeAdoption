struct UserDetailsResponse: Decodable {
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
}
