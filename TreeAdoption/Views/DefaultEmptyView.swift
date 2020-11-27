import SwiftUI

struct DefaultEmptyView: View {
    let imageSystemName: String
    let message: LocalizedStringKey

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: imageSystemName)
                    .font(.system(size: 56))
                    .foregroundColor(.primaryGray)
                Text(message)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primaryGray)
                    .padding(.top, 16)
            }
            Spacer()
        }
    }
}

struct DefaultEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultEmptyView(imageSystemName: "calendar", message: "Message")
    }
}
