import Combine
import SwiftUI

struct PersonalizeTreeView: View {
    @Binding var isPresented: Bool

    @ObservedObject var viewModel: PersonalizeTreeViewModel
    @Environment(\.openURL) var openURL

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundGray
                .ignoresSafeArea()
            VStack(spacing: 0) {
                TextField(
                    "personalize_tree_view_tree_name_label",
                    text: $viewModel.treeName
                )
                .font(.system(size: 35, weight: .heavy))
                .lineLimit(1)
                .padding(.top, 24)
                Rectangle()
                    .fill(Color.primaryGray)
                    .frame(maxWidth: .infinity, maxHeight: 0.6)
                HStack {
                    Text("personalize_tree_view_add_personal_sign_label")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.textPrimary)
                    Toggle("", isOn: $viewModel.addPersonalSign)
                }
                .padding(.top, 24)
                ZStack {
                    ZStack(alignment: .center) {
                        VStack(spacing: 0) {
                            TextField(
                                "personalize_tree_view_your_text_label",
                                text: $viewModel.signTitle
                            )
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.textPrimary)
                            .disabled(!viewModel.addPersonalSign)
                            Rectangle()
                                .fill(Color.primaryGray)
                                .frame(maxWidth: .infinity, maxHeight: 0.6)
                        }
                        .padding(24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 230)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primaryGray, lineWidth: 1)
                    )
                    if !viewModel.addPersonalSign {
                        Color.primary
                            .opacity(0.1)
                            .frame(maxHeight: 230)
                            .cornerRadius(20)
                    }
                }
                .padding(.top, 24)
                Text("personalize_tree_view_sign_description")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primaryGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            DefaultButton(
                titleKey: "personalize_tree_view_adopt_button_title",
                action: {
                    viewModel.adoptThisTreePressed(success: { url in
                        openURL(URL(string: url)!)
                    })
                },
                disabled: $viewModel.continueDisabled
            )
            .padding(.bottom, 24)
            NavigationLink(
                "",
                destination: PaymentStatusView(
                    viewModel: PaymentStatusViewModel(WebPaymentStatusProvider(NetworkClient()), viewModel.paymentID)
                ),
                isActive: $viewModel.showPaymentStatus
            )
        }
        .navigationBarTitle("personalize_tree_view_title", displayMode: .inline)
        .navigationBarItems(
            trailing: NavigationTextButton(
                action: { isPresented.toggle() },
                titleKey: "personalize_tree_view_done_button_label"
            )
        )
    }
}

struct PersonalizeTreeViewPreviews: PreviewProvider {
    static var previews: some View {
        PersonalizeTreeView(
            isPresented: .constant(true),
            viewModel: PersonalizeTreeViewModel(
                PreviewProvider(),
                "1"
            )
        )
    }

    private class PreviewProvider: CreateOrderInteractor {
        func createOrder(userId _: Int, productId _: Int) -> AnyPublisher<Result<WebCreateOrderResponse, RequestError>, Never> {
            return Just(Result.failure(.genericError(NSError()))).eraseToAnyPublisher()
        }
    }
}
