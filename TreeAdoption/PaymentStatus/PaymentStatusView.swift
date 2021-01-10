import SwiftUI

struct PaymentStatusView: View {
    @ObservedObject var viewModel: PaymentStatusViewModel

    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            switch viewModel.state {
                case .loading:
                    DefaultLoadingView()
                case let .loaded(result):
                    if case PaymentResult.paid = result {
                        PaymentSuccessView()
                    } else {
                        PaymentFailedView()
                    }
                case .error:
                    PaymentFailedView()
            }
        }
        .navigationBarTitle("payment_status_view_title", displayMode: .inline)
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct PaymentFailedView: View {
    var body: some View {
        VStack {
            Image("ic_status_failed")
            Text("payment_status_view_network_error_title")
                .font(.headline)
                .foregroundColor(Color.textPrimary)
                .padding(.top, 16)
            Text("payment_status_view_network_error_message")
                .font(.footnote)
                .foregroundColor(Color.textPrimary)
        }
    }
}

struct PaymentSuccessView: View {
    var body: some View {
        VStack {
            Image("ic_status_success")
            Text("payment_status_view_success_title")
                .font(.headline)
                .foregroundColor(Color.textPrimary)
                .padding(.top, 16)
            Text("payment_status_view_success_message")
                .font(.footnote)
                .foregroundColor(Color.textPrimary)
        }
    }
}

struct PaymentStatusViewPreviews: PreviewProvider {
    static var previews: some View {
        PaymentStatusView(viewModel: PaymentStatusViewModel(WebOrderServiceProvider()))
    }
}
