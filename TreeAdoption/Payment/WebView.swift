import Combine
import SwiftUI
import WebKit

public class WebViewStore: ObservableObject {
    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }

    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        setupObservers()
    }

    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward)
        ]
    }

    private var observers: [NSKeyValueObservation] = []

    deinit {
        observers.forEach {
            $0.invalidate()
        }
    }
}

public struct WebView: View, UIViewRepresentable {
    public let webView: WKWebView

    public typealias UIViewType = UIViewContainerView<WKWebView>

    public init(webView: WKWebView) {
        self.webView = webView
    }

    public func makeUIView(context _: UIViewRepresentableContext<WebView>) -> WebView.UIViewType {
        return UIViewContainerView()
    }

    public func updateUIView(_ uiView: WebView.UIViewType, context: UIViewRepresentableContext<WebView>) {
        if uiView.contentView !== webView {
            uiView.contentView = webView
            webView.uiDelegate = context.coordinator
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(webView)
    }
}

public class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
    var parent: WKWebView

    init(_ parent: WKWebView) {
        self.parent = parent
    }

    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation _: WKNavigation!) {
        guard let url = webView.url?.absoluteString else {
            print("NO URL")
            return
        }
        print(url)
    }
}

public class UIViewContainerView<ContentView: UIView>: UIView, WKNavigationDelegate {
    var contentView: ContentView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            if let contentView = contentView {
                addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
        }
    }
}
