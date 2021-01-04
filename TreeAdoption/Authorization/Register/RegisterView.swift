import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                VStack {
                    TextField("register_view_first_name_input_label", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("register_view_last_name_input_label", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("register_view_username_input_label", text: $viewModel.userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("register_view_email_input_label", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("register_view_password_input_label", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("register_view_repeat_password_input_label", text: $viewModel.repeatPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Spacer()
                DefaultButton(
                    titleKey: "register_view_register_button_label",
                    action: viewModel.registerPressed,
                    disabled: .constant(false)
                )
                .padding(.top, 24)
            }
            .padding(24)
        }
        .alert(isPresented: $viewModel.errorVisible) {
            Alert(
                title: Text("register_view_network_error_title"),
                message: Text("register_view_network_error_message"),
                dismissButton: .default(Text("register_view_network_error_button_label"))
            )
        }
        .navigationBarTitle("register_view_title")
    }
}

struct RegisterViewPreviews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel(
            AccountCreator(
                CreateAccountService(NetworkClient()),
                WebUserDetailsService(NetworkClient()),
                LoginService(NetworkClient()),
                TokenArchiver(),
                UserPersister()
            ),
            PreviewListener()
        )
        )
    }

    fileprivate class PreviewListener: RegisterViewEvents {
        func onAuthorised() {}
    }
}
