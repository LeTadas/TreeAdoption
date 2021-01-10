struct RefreshTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
    }
}
