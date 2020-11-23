import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            VStack {
                Spacer()
                TextField("login_view_email_input_label", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("login_view_password_input_label", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 8)
                HStack {
                    Button(action: viewModel.forgotPasswordPressed) {
                        Text("login_view_forgot_password_button_label")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.accentColor)
                    }
                    .padding(.top, 8)
                    Spacer()
                }
                Spacer()
                Button(action: viewModel.noAccountPressed) {
                    Text("login_view_no_account_button_label")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.accentColor)
                }
                .padding(.top, 8)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            DefaultButton(titleKey: "Login", action: viewModel.loginPressed)
                .padding(.top, 24)
        }
        .navigationBarTitle("login_view_title")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
