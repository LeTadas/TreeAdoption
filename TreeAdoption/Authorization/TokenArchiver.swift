import Foundation

struct TokenArchiver {
    static let shared = TokenArchiver()

    private let accessTokenKey = "adopt_tree_access_token_key"
    private let refreshTokenKey = "adopt_tree_refresh_token_key"

    func getAccessToken() -> String? {
        let token = UserDefaults.standard.string(forKey: accessTokenKey)

        guard let accessToken = token else {
            return nil
        }
        return accessToken
    }

    func storeAccessToken(token: String?) {
        print("Storing access token: \(token)")
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }

    func getRefreshToken() -> String? {
        let token = UserDefaults.standard.string(forKey: refreshTokenKey)

        guard let refreshToken = token else {
            return nil
        }
        return refreshToken
    }

    func storeRefreshToken(token: String?) {
        print("Storing refresh token: \(token)")
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }

    func deleteTokens() {
        UserDefaults.standard.set(nil, forKey: accessTokenKey)
        UserDefaults.standard.set(nil, forKey: refreshTokenKey)
    }
}
