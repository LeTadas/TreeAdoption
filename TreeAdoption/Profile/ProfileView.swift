import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                ScrollView {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 90, height: 90)
                            Circle()
                                .stroke(Color.primaryGray, lineWidth: 2)
                                .frame(width: 90, height: 90)
                            Text(viewModel.firstNameLetter)
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.primaryGray)
                        }
                        Text(viewModel.loggedInAs)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primaryGray)
                            .padding(.top, 16)
                        GoalView()
                        VStack {
                            HeaderView(titleKey: "profile_view_settings_visits_header_label")
                                .padding(.top, 16)
                            RowView(
                                titleKey: "profile_view_settings_visits_row_label",
                                titleColor: .textPrimary,
                                navigationRow: true,
                                onPressed: {}
                            )
                            HeaderView(titleKey: "profile_view_settings_profile_header_label")
                                .padding(.top, 16)
                            ZStack {
                                Color.white
                                VStack(spacing: 0) {
                                    RowView(
                                        titleKey: "profile_view_settings_change_email_row_label",
                                        titleColor: .textPrimary,
                                        navigationRow: true,
                                        onPressed: {}
                                    )
                                    DividerView()
                                    RowView(
                                        titleKey: "profile_view_settings_change_password_row_label",
                                        titleColor: .textPrimary,
                                        navigationRow: true,
                                        onPressed: {}
                                    )
                                    DividerView()
                                    RowView(
                                        titleKey: "profile_view_settings_delete_account_row_label",
                                        titleColor: .accentColor,
                                        navigationRow: true,
                                        onPressed: {}
                                    )
                                    DividerView()
                                    RowView(
                                        titleKey: "profile_view_settings_logout_row_label",
                                        titleColor: .textPrimary,
                                        navigationRow: false,
                                        onPressed: viewModel.logout
                                    )
                                }
                            }
                            .cornerRadius(10)
                        }
                    }
                    .padding(24)
                }
                .navigationBarTitle("profile_view_title", displayMode: .inline)
                .onAppear(perform: viewModel.onAppear)
            }
        }
    }
}

struct DividerView: View {
    var body: some View {
        Rectangle()
            .fill(Color.backgroundGray)
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding(.leading, 12)
    }
}

struct HeaderView: View {
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

struct RowView: View {
    let titleKey: LocalizedStringKey
    let titleColor: Color
    let navigationRow: Bool
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
                if navigationRow {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(Color.primaryGray)
                }
            }
            .padding(12)
        }
        .cornerRadius(10)
        .onTapGesture {
            onPressed()
        }
    }
}

struct GoalView: View {
    var body: some View {
        ZStack {
            Color.white
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
                GoalGraph()
                    .padding(.top, 16)
            }
            .padding(16)
        }
        .cornerRadius(20)
    }
}

struct GoalGraph: View {
    var body: some View {
        HStack(alignment: .bottom) {
            GoalItem(fraction: 0.1)
            Spacer()
            GoalItem(fraction: 0.8)
            Spacer()
            GoalItem(fraction: 0.4)
            Spacer()
            GoalItem(fraction: 0.6)
            Spacer()
            GoalItem(fraction: 0.9)
        }
    }
}

struct GoalItem: View {
    let fraction: CGFloat

    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.primaryColor)
                .frame(width: 45, height: fraction * 100)
                .cornerRadius(10)
            Text("Aug")
                .font(.system(size: 13, weight: .heavy))
                .foregroundColor(Color.textPrimary)
        }
        .frame(maxHeight: 140)
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: ProfileViewModel(
                PreviewEvents(),
                UserPersister(),
                TokenArchiver()
            )
        )
    }

    fileprivate class PreviewEvents: ProfileViewEvents {
        func onLoggedOut() {}
    }
}
