import Combine
import Foundation

enum MyTreesState {
    case loading
    case loaded([TreeOverview])
    case empty
    case error
}

class MyTreesViewModel: ObservableObject {
    @Published var state: MyTreesState = .loaded(
        [
            TreeOverview(id: 0, name: "White oak", imageUrl: "https://www.fillmurray.com/200/300", humidity: 12.3, temperature: 1.2, lenght: 120),
            TreeOverview(id: 1, name: "Birtch", imageUrl: "https://www.fillmurray.com/200/300", humidity: 12.3, temperature: 1.2, lenght: 120)
        ]
    )
}

extension MyTreesViewModel {
    func adoptTreePressed() {}
}

struct TreeOverview {
    let id: Int
    let name: String
    let imageUrl: String
    let humidity: Double
    let temperature: Double
    let lenght: Double
}
