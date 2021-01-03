import SwiftUI

struct PaymentStatusView: View {
    @ObservedObject var viewModel: PaymentStatusViewModel

    var body: some View {
        ZStack {
            Color.backgroundGray
            PaymentSuccessView()
        }
        .navigationBarTitle("news_view_title", displayMode: .inline)
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct PaymentFailedView: View {
    var body: some View {
        VStack {
            Image("ic_status_failed")
            Text("Oops")
            Text("Payment failed please try again later")
        }
    }
}

struct PaymentSuccessView: View {
    var body: some View {
        VStack {
            Image("ic_status_success")
            Text("Payment was successful")
        }
    }
}
