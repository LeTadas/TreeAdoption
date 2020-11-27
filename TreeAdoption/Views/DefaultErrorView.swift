import SwiftUI

struct DefaultErrorView: View {
    let titleKey: LocalizedStringKey
    let messageKey: LocalizedStringKey

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(titleKey)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primaryGray)
                Text(messageKey)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primaryGray)
                    .lineLimit(2)
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
            }
            Spacer()
        }
    }
}

struct DefaultErrorView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultErrorView(titleKey: "Error", messageKey: "Message")
    }
}
