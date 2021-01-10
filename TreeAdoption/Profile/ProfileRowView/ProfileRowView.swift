import SwiftUI

struct ProfileRowView: View {
    let titleKey: LocalizedStringKey
    let titleColor: Color
    let onPressed: () -> Void

    var body: some View {
        ZStack {
            Color.white
            HStack {
                Text(titleKey)
                    .font(.system(size: 17, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(titleColor)
                Spacer()
            }
            .padding(12)
        }
        .cornerRadius(10)
        .onTapGesture {
            onPressed()
        }
    }
}

struct ProfileRowViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileRowView(titleKey: "Title", titleColor: Color.textPrimary, onPressed: {})
    }
}
