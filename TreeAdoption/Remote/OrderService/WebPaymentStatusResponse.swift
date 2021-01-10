struct WebPaymentStatusResponse: Decodable {
    let id: Int
    let paymentStatus: String

    enum CodingKeys: String, CodingKey {
        case id
        case paymentStatus
    }
}
