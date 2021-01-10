import Foundation

struct OrderCache {
    static let shared = OrderCache()

    private let orderKey = "adopt_tree_order_id_key"

    func getOrderId() -> Int? {
        return UserDefaults.standard.integer(forKey: orderKey)
    }

    func storeOrderId(id: Int) {
        UserDefaults.standard.set(id, forKey: orderKey)
    }

    func deleteTokens() {
        UserDefaults.standard.set(nil, forKey: orderKey)
    }
}
