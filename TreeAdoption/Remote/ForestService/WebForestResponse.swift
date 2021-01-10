import Foundation

struct WebForestResponse: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        guard let latitudeString = try? container.decode(String.self, forKey: .latitude) else {
            fatalError("Could not parse latitude WebForestResponse")
        }

        guard let longitudeString = try? container.decode(String.self, forKey: .longitude) else {
            fatalError("Could not parse longitude WebForestResponse")
        }

        latitude = Double(latitudeString)!
        longitude = Double(longitudeString)!
    }
}
