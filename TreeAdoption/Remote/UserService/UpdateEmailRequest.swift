struct UpdateEmailRequest: Encodable {
    let email: String

    enum CodingKeys: String, CodingKey {
        case email
    }
}
