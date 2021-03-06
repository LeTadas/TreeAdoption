import Foundation

struct UserPersister {
    static let shared = UserPersister()

    private let userKey = "adopt_tree_user_key"

    func getUser() -> User? {
        if let userData = UserDefaults.standard.object(forKey: userKey) as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: userData) {
                print("USER: \(user)")
                return user
            }
        }

        return nil
    }

    func storeUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    func deleteUser() {
        UserDefaults.standard.set(nil, forKey: userKey)
    }
}
