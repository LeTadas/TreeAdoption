import Combine

class PersonalizeTreeViewModel: ObservableObject {
    @Published var addPersonalSign: Bool = false
    @Published var treeName: String = "" {
        didSet {
            updateButton()
        }
    }

    @Published var signTitle: String = ""
    @Published var continueDisabled: Bool = true

    func updateButton() {
        continueDisabled = treeName.isEmpty
    }
}

extension PersonalizeTreeViewModel {
    func adoptThisTreePressed() {}
}
