import SwiftUI

struct ProfileHeaderView: View {
    let firstLetter: String
    let loggedInAs: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 90, height: 90)
                Circle()
                    .stroke(Color.primaryGray, lineWidth: 2)
                    .frame(width: 90, height: 90)
                Text(firstLetter)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.primaryGray)
            }
            Text(loggedInAs)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primaryGray)
                .padding(.top, 16)
        }
    }
}

struct ProfileHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(firstLetter: "S", loggedInAs: "test@email.com")
            .previewLayout(.fixed(width: 300, height: 150))
    }
}
