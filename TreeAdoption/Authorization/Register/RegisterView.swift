import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()

    var body: some View {
        VStack {
            Spacer()
            VStack {
                TextField("register_view_email_input_label", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("register_view_password_input_label", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 8)
                TextField("register_view_repeat_password_input_label", text: $viewModel.repeatPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 8)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            DefaultButton(
                titleKey: "register_view_register_button_label",
                action: viewModel.registerPressed,
                disabled: .constant(false)
            )
            .padding(.top, 24)
            Spacer()
        }
        .navigationBarTitle("register_view_title")
    }
}

struct RegisterViewPreviews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
