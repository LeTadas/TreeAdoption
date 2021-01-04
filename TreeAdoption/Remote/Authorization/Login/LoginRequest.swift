struct LoginRequest: Encodable {
    let username: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
