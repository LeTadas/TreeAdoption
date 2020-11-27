struct WebAdoptTreeResponse: Decodable {
	let id: Int
	let categoryId: Int
	let name: String
	let description: String
	let price: Int
	let vatRateId: Int
	let isUpForAdoption: Bool
	let stock: Int

	enum CodingKeys: String, CodingKey {
		case id
		case categoryId
		case name
		case description
		case price
		case vatRateId
		case isUpForAdoption
		case stock
	}
}
