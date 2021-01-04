import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                Text("onboarding_view_title")
                    .font(.system(size: 45, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 307)
                    .foregroundColor(.white)
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: LoginView(
                                viewModel: LoginViewModel(
                                    LoginViewListener(viewModel)
                                )
                            )
                        ) {
                            ZStack {
                                Rectangle()
                                    .fill(Color("primaryColor"))
                                    .cornerRadius(20)
                                HStack {
                                    Text("onboarding_view_begin_button_title")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.forward.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 160, height: 40)
                            .padding(.trailing, 24)
                        }
                    }
                }
            }
            .background(
                Image("background")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel(PreviewEvents()))
    }

    fileprivate class PreviewEvents: OnboardingViewEvents {
        func onAuthorised() {}
    }
}

private class LoginViewListener: LoginViewEvents {
    private unowned let parent: OnboardingViewModel

    init(_ parent: OnboardingViewModel) {
        self.parent = parent
    }

    func onAuthorised() {
        parent.onAuthorised()
    }
}
