import SwiftUI

struct DefaultButton: View {
    let titleKey: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(Color("primaryColor"))
                    .cornerRadius(20)
                HStack {
                    Text(titleKey)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 220, height: 40)
        }
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(titleKey: "Login", action: {})
    }
}
