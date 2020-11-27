import SwiftUI

struct DefaultLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct DefaultLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultLoadingView()
    }
}
