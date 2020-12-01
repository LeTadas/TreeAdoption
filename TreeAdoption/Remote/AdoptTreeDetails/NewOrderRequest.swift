struct NewOrderRequest: Encodable {
    let userId: Int
    let orderLines: [OrderLine]

    enum CodingKeys: String, CodingKey {
        case userId
        case orderLines
    }
}

struct OrderLine: Encodable {
    let productId: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case productId
        case quantity
    }
}
