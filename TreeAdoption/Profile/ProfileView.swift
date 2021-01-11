import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        ProfileHeaderView(
                            firstLetter: viewModel.firstNameLetter,
                            loggedInAs: viewModel.loggedInAs
                        )
                        GoalView()
                            .padding(.top, 16)
                        VStack {
                            ProfileSectionView(titleKey: "profile_view_settings_visits_header_label")
                                .padding(.top, 16)
                            NavigationLink(destination: MyVisitsView()) {
                                ProfileNavigationRowView(
                                    titleKey: "profile_view_settings_visits_row_label",
                                    titleColor: .textPrimary
                                )
                            }
                            ProfileSectionView(titleKey: "profile_view_settings_profile_header_label")
                                .padding(.top, 16)
                            VStack(spacing: 0) {
                                NavigationLink(destination: ChangeEmailView()) {
                                    ProfileNavigationRowView(
                                        titleKey: "profile_view_settings_change_email_row_label",
                                        titleColor: .textPrimary
                                    )
                                }
                                DividerView()
                                ProfileRowView(
                                    titleKey: "profile_view_settings_change_password_row_label",
                                    titleColor: .textPrimary,
                                    onPressed: {}
                                )
                                DividerView()
                                ProfileRowView(
                                    titleKey: "profile_view_settings_delete_account_row_label",
                                    titleColor: .accentColor,
                                    onPressed: {}
                                )
                                DividerView()
                                ProfileRowView(
                                    titleKey: "profile_view_settings_logout_row_label",
                                    titleColor: .textPrimary,
                                    onPressed: viewModel.logout
                                )
                            }
                            .background(CardBackground())
                        }
                    }
                    .padding(24)
                    .padding(.bottom, 32)
                }
                .navigationBarTitle("profile_view_title", displayMode: .large)
                .onAppear(perform: viewModel.onAppear)
            }
        }
    }
}

struct ProfileScenePreviews: PreviewProvider {
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
