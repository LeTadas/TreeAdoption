import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let standard = UINavigationBarAppearance()
        standard.backgroundColor = .white

        let compact = UINavigationBarAppearance()
        compact.backgroundColor = .white

        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.configureWithTransparentBackground()

        navigationBar.standardAppearance = standard
        navigationBar.compactAppearance = compact
        navigationBar.scrollEdgeAppearance = scrollEdge

        navigationBar.tintColor = UIColor(named: "primaryColor")
    }
}
