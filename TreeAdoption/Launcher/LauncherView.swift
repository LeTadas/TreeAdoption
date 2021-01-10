import SwiftUI

struct LauncherView: View {
    @ObservedObject var viewModel: LauncherViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                Text("launcher_view_title")
                    .font(.system(size: 41, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 307)
                    .foregroundColor(.white)
            }
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .navigationBarHidden(true)
            .onAppear(perform: viewModel.onAppear)
            .ignoresSafeArea()
        }
    }
}

struct LauncherViewPreviews: PreviewProvider {
    static var previews: some View {
        LauncherView(viewModel: LauncherViewModel(PreviewListener(), TokenArchiver()))
    }

    private class PreviewListener: LauncherViewEvents {
        func onAuthenticated() {}
        func onUnauthenticated() {}
    }
}
