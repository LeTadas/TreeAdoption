struct BookTourResponse: Decodable {
    let id: Int
    let tourId: Int
    let userId: Int
    let userName: String
    let userEmail: String

    enum CodingKeys: String, CodingKey {
        case id
        case tourId
        case userId
        case userName
        case userEmail
    }
}
