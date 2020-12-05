import Combine
import Foundation

class MyTreesViewModel: ObservableObject {
    private let webMyTreeProvider: DefaultMyTreeProvider
    private var bag = Set<AnyCancellable>()

    init(_ webMyTreeProvider: DefaultMyTreeProvider) {
        self.webMyTreeProvider = webMyTreeProvider
    }

    deinit {
        bag.removeAll()
    }

    @Published var state: ViewState<[TreeSummary]> = .loading

    @Published var showAdoptView: Bool = false
}

extension MyTreesViewModel {
    func adoptTreePressed() {
        showAdoptView = true
    }

    func onAppear() {
        webMyTreeProvider.getTreeSummaries()
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        self.state = .loaded(result)
                    case .failure:
                        self.state = .error
                }
            }
            .store(in: &bag)
    }
}
