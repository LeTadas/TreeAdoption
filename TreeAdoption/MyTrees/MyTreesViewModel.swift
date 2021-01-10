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
        webMyTreeProvider.getAdoptedTrees()
            .sink { [unowned self] value in
                switch value {
                    case let .success(result):
                        self.state = .loaded(result)
                    case let .failure(error):
                        if case let RequestError.networkError(networkError) = error {
                            if networkError.rawValue == 404 {
                                self.state = .loaded([])
                                return
                            }
                            self.state = .error
                        }
                        self.state = .error
                }
            }
            .store(in: &bag)
    }

    func onDisappear() {
        bag.removeAll()
    }
}
