struct BookTourRequest: Encodable {
    let tourId: Int
    let userId: Int
    let userName: String
    let userEmail: String
    let bookedDateTime: String

    enum CodingKeys: String, CodingKey {
        case tourId
        case userId
        case userName
        case userEmail
        case bookedDateTime
    }
}
