import SwiftUI

struct ChangeEmailView: View {
    @ObservedObject var viewModel = ChangeEmailViewModel(
        DefaultChangeEmailInteractor(
            WebUserService(),
            LoginService()
        )
    )

    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            VStack {
                TextField("change_email_view_current_username_input_placeholder", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("change_email_view_new_email_input_placeholder", text: $viewModel.newEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("change_email_view_repeat_new_email_input_placeholder", text: $viewModel.repeatNewEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("change_email_view_password_input_placeholder", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DefaultButton(
                    titleKey: "change_email_button_title",
                    action: {},
                    disabled: $viewModel.buttonDisabled
                )
                .padding(.top, 24)
            }
            .padding(24)
            .background(CardBackground())
            .padding(24)
        }
        .navigationBarTitle("change_email_view_title", displayMode: .large)
        .alert(isPresented: $viewModel.alertVisible) {
            switch viewModel.alertType {
                case .success:
                    return Alert(
                        title: Text("change_email_success_alert_title"),
                        message: Text("change_email_success_alert_message"),
                        dismissButton: .default(Text("change_email_alert_ok_button"))
                    )
                case .error:
                    return Alert(
                        title: Text("change_email_error_alert_title"),
                        message: Text("change_email_error_alert_message"),
                        dismissButton: .default(Text("change_email_alert_ok_button"))
                    )
            }
        }
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
    }
}
