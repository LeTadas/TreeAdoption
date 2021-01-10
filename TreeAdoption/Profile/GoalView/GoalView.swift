import SwiftUI

struct GoalView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("profile_view_goal_title")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("profile_view_goal_message")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color.primaryGray)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
            HStack(alignment: .bottom) {
                GoalItemView(title: "Jan", fraction: 0.1)
                Spacer()
                GoalItemView(title: "Feb", fraction: 0.8)
                Spacer()
                GoalItemView(title: "Mar", fraction: 0.4)
                Spacer()
                GoalItemView(title: "Apr", fraction: 0.6)
                Spacer()
                GoalItemView(title: "May", fraction: 0.9)
            }
            .padding(.top, 16)
        }
        .padding(16)
        .background(CardBackground())
    }
}

struct GoalViewPreviews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
