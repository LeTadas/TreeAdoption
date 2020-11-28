import Combine
import Foundation

class MyTreesViewModel: ObservableObject {
    private let webTreeOverviewProvider: TreeOverviewProvider
    private var bag = Set<AnyCancellable>()

    init(_ webTreeOverviewProvider: TreeOverviewProvider) {
        self.webTreeOverviewProvider = webTreeOverviewProvider
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<[TreeOverview]> = .loaded(
        [
            TreeOverview(id: 0, name: "White oak", imageUrl: "https://www.fillmurray.com/200/300", humidity: 12.3, temperature: 1.2, lenght: 120),
            TreeOverview(id: 1, name: "Birtch", imageUrl: "https://www.fillmurray.com/200/300", humidity: 12.3, temperature: 1.2, lenght: 120)
        ]
    )

    @Published var showAdoptView: Bool = false
}

extension MyTreesViewModel {
    func adoptTreePressed() {
        showAdoptView = true
    }

    func onAppear() {
        webTreeOverviewProvider.getTreeOverview()
            .sink { value in
                print(value)
            }
            .store(in: &bag)
    }
}

struct TreeOverview {
    let id: Int
    let name: String
    let imageUrl: String
    let humidity: Double
    let temperature: Double
    let lenght: Double
}
