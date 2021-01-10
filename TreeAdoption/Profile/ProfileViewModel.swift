import Combine
import SwiftUI
import UIKit
protocol ProfileViewEvents {
    func onLoggedOut()
}

class ProfileViewModel: ObservableObject {
    private let listener: ProfileViewEvents
    private let userPersister: UserPersister
    private let tokenArchiver: TokenArchiver

    init(
        _ listener: ProfileViewEvents,
        _ userPersister: UserPersister,
        _ tokenArchiver: TokenArchiver
    ) {
        self.listener = listener
        self.userPersister = userPersister
        self.tokenArchiver = tokenArchiver
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

    func viewVisits() {}

    func logout() {
        listener.onLoggedOut()
        userPersister.deleteUser()
        tokenArchiver.deleteTokens()
    }
}
