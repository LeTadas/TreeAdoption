struct WebCreateOrderResponse: Decodable {
    let id: Int
    let paymentLink: String

    enum CodingKeys: String, CodingKey {
        case id
        case paymentLink
    }
}
