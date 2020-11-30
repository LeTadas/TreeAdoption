import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel = ForgotPasswordViewModel()

    var body: some View {
        VStack {
            Spacer()
            TextField("forgot_password_view_email_input_label", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 24)
                .padding(.trailing, 24)
            DefaultButton(
                titleKey: "forgot_password_view_reset_button_label",
                action: viewModel.restPressed,
                disabled: .constant(false)
            )
            .padding(.top, 24)
            Spacer()
        }
        .navigationBarTitle("forgot_password_view_title")
    }
}

struct ForgotPasswordViewPreviews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
