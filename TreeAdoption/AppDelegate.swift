import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.host! == "payment-return" {
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            let paymentId = queryItems?.filter { $0.name == "id" }.first

            print("Query Items: \(queryItems)")
            print("PaymentId: \(paymentId)")
            return true
        }
        return false
    }
}
