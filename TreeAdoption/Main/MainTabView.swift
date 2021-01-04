import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainTabViewModel

    init(viewModel: MainTabViewModel) {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "primaryGray")
        UITabBar.appearance().barTintColor = .white
        self.viewModel = viewModel
    }

    var body: some View {
        TabView {
            MyTreesView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("main_tab_view_my_trees_label")
                }
            NewsView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("main_tab_view_news_label")
                }
            ProfileView(
                viewModel: ProfileViewModel(
                    ProfileViewListener(viewModel),
                    UserPersister(),
                    TokenArchiver()
                )
            )
            .tabItem {
                Image(systemName: "person.fill")
                Text("main_tab_view_profile_label")
            }
        }
        .accentColor(.primaryColor)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel(PreviewListener()))
    }

    fileprivate class PreviewListener: MainTabViewEvents {
        func onLoggedOut() {}
    }
}

private class ProfileViewListener: ProfileViewEvents {
    private unowned let viewModel: MainTabViewModel

    init(_ viewModel: MainTabViewModel) {
        self.viewModel = viewModel
    }

    func onLoggedOut() {
        viewModel.onLoggedOut()
    }
}
