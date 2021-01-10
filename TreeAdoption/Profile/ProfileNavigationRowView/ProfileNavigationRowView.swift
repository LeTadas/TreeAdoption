import SwiftUI

struct ProfileNavigationRowView: View {
    let titleKey: LocalizedStringKey
    let titleColor: Color

    var body: some View {
        HStack {
            Text(titleKey)
                .font(.system(size: 17, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(titleColor)
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(Color.primaryGray)
        }
        .padding(12)
        .background(CardBackground())
    }
}

struct ProfileNavigationRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileNavigationRowView(titleKey: "Navigation Row", titleColor: Color.textPrimary)
    }
}
