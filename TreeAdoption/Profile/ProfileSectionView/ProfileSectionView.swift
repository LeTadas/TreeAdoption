import SwiftUI

struct ProfileSectionView: View {
    let titleKey: LocalizedStringKey

    var body: some View {
        Text(titleKey)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(Color.primaryGray)
            .textCase(.uppercase)
            .padding(.leading, 12)
            .padding(.trailing, 12)
    }
}

struct ProfileSectionViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileSectionView(titleKey: "Section title")
            .previewLayout(.fixed(width: 300, height: 40))
    }
}
