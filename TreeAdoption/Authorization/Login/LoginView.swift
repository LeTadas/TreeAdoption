import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            VStack {
                Spacer()
                TextField("login_view_email_input_label", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("login_view_password_input_label", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("login_view_forgot_password_button_label")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.top, 8)
                    Spacer()
                }
                Spacer()
                DefaultButton(
                    titleKey: "login_view_login_button_label",
                    action: viewModel.loginPressed,
                    disabled: .constant(false)
                )
                .padding(.bottom, 24)
                NavigationLink(
                    destination: RegisterView(
                        viewModel: RegisterViewModel(
                            AccountCreator(
                                CreateAccountService(NetworkClient()),
                                LoginService(NetworkClient()),
                                TokenArchiver()
                            ),
                            RegisterViewListener(viewModel)
                        )
                    )
                ) {
                    Text("login_view_no_account_button_label")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(24)
        }
        .navigationBarTitle("login_view_title")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(
            PreviewEvents(),
            Authenticator(
                LoginService(NetworkClient()),
                TokenArchiver()
            )
        )
        )
    }

    fileprivate class PreviewEvents: LoginViewEvents {
        func onAuthorised() {}
    }
}

private class RegisterViewListener: RegisterViewEvents {
    private unowned let parent: LoginViewModel

    init(_ parent: LoginViewModel) {
        self.parent = parent
    }

    func onAuthorised() {
        parent.onAuthorised()
    }
}
