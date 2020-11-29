import SwiftUI

struct DefaultButton: View {
    let titleKey: LocalizedStringKey
    let action: () -> Void
    @Binding var disabled: Bool

    var body: some View {
        Button(action: action) {
            Text(titleKey)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .disabled(disabled)
        .frame(width: 220, height: 40)
        .background(Color("primaryColor").opacity(disabled ? 0.5 : 1))
        .cornerRadius(20)
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(titleKey: "Login", action: {}, disabled: .constant(false))
    }
}
