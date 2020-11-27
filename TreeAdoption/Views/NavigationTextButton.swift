import SwiftUI

struct NavigationTextButton: View {
    let action: () -> Void
    let titleKey: LocalizedStringKey

    var body: some View {
        Button(action: action) {
            Text(titleKey)
                .foregroundColor(.primaryColor)
        }
    }
}

struct NavigationTextButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTextButton(action: {}, titleKey: "")
    }
}
