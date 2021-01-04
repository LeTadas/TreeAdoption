struct CreateAccountRequest: Encodable {
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case username
        case email
        case password
    }
}
