import Combine

class AdoptTreeViewModel: ObservableObject {
    private let availableTreesProvider: AvailableTreesForAdoptionProvider
    private var bag = Set<AnyCancellable>()

    init(_ availableTreesProvider: AvailableTreesForAdoptionProvider) {
        self.availableTreesProvider = availableTreesProvider
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: AdoptTreeState = .loading
}

extension AdoptTreeViewModel {
    func onAppear() {
        availableTreesProvider.getAvailableTrees()
            .sink { [unowned self] value in
                switch value {
                    case let .success(items):
                        self.state = .loaded(items)
                    case let .failure(error):
                        print("Network error: \(error.localizedDescription)")
                        self.state = .error
                }
            }
            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}

enum AdoptTreeState {
    case loading
    case loaded([AdoptTreeItem])
    case error
}

struct AdoptTreeItem {
    let id: Int
    let name: String
    let category: Int
    let description: String
    let price: Int
    let stock: Int
}
