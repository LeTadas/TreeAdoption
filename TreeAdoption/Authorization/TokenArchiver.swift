import Foundation
import KeychainAccess

struct TokenArchiver {
    private let keychain = Keychain()
    private let accessTokenKey = "adopt_tree_access_token_key"
    private let refreshTokenKey = "adopt_tree_refresh_token_key"

    func getAccessToken() -> String? {
        let token = try? keychain.get(accessTokenKey)

        guard let accessToken = token else {
            return nil
        }
        return accessToken
    }

    func storeAccessToken(token: String?) {
        if let accessToken = token {
            try? keychain.set(accessToken, key: accessTokenKey)
        } else {
            try? keychain.remove(accessTokenKey)
        }
    }

    func getRefreshToken() -> String? {
        let token = try? keychain.get(refreshTokenKey)

        guard let refreshToken = token else {
            return nil
        }
        return refreshToken
    }

    func storeRefreshToken(token: String?) {
        if let refreshToken = token {
            try? keychain.set(refreshToken, key: refreshTokenKey)
        } else {
            try? keychain.remove(refreshTokenKey)
        }
    }
}
