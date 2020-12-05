import SwiftUI

struct PaymentView: View {
    @Binding var isPresented: Bool

    @ObservedObject var webViewStore = WebViewStore()

    let paymentLink: String

    var body: some View {
        WebView(webView: webViewStore.webView)
            .navigationBarTitle(Text("payment_view_title"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                Button(
                    "payment_view_cancel_button_label",
                    action: { isPresented.toggle() }
                )
            )
            .onAppear {
                self.webViewStore.webView.load(
                    URLRequest(
                        url: URL(string: paymentLink)!
                    )
                )
            }
    }
}
