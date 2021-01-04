import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    private let user: User

    init(_ user: User) {
        self.user = user
    }

    var firstNameLetter: String {
        if user.email.isEmpty { return "" }
        return String(user.email.first ?? Character("")).capitalized
    }

    var loggedInAs: String {
        return String(
            format: NSLocalizedString("profile_view_logged_in_as", comment: ""),
            user.email
        )
    }
}
