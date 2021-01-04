import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    private let userPersister: UserPersister

    init(_ userPersister: UserPersister) {
        self.userPersister = userPersister
    }

    @Published var firstNameLetter: String = ""
    @Published var loggedInAs: String = ""
}

extension ProfileViewModel {
    func onAppear() {
        guard let user = userPersister.getUser() else {
            return
        }

        firstNameLetter = String(user.email.first ?? Character("")).capitalized
        loggedInAs = String(
            format: NSLocalizedString("profile_view_logged_in_as", comment: ""),
            user.email
        )
    }
}
