import SwiftUI

struct GoalItemView: View {
    let title: String
    let fraction: CGFloat

    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.primaryColor)
                .frame(width: 45, height: fraction * 100)
                .cornerRadius(10)
            Text(title)
                .font(.system(size: 13, weight: .heavy))
                .foregroundColor(Color.textPrimary)
        }
        .frame(maxHeight: 140)
    }
}

struct GoalItemViewPreviews: PreviewProvider {
    static var previews: some View {
        GoalItemView(title: "Aug", fraction: 0.2)
    }
}
