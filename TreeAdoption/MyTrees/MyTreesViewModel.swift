import Combine
import Foundation

enum MyTreesSheets {
    case adoptTree
    case paymentStatus
}

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

    @Published var sheetVisible: Bool = false
    var sheet: MyTreesSheets = .adoptTree
}

extension MyTreesViewModel {
    func handleUrl(url: URL) {
        if url.host! == "payment-return" {
            sheet = .paymentStatus
            sheetVisible = true
        }
    }

    func adoptTreePressed() {
        sheet = .adoptTree
        sheetVisible = true
    }

    func refresh() {
        webMyTreeProvider.refresh()
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
