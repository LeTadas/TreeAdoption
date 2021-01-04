import SwiftUI

struct MainTabView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "primaryGray")
        UITabBar.appearance().barTintColor = .white
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
                    UserPersister()
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
        MainTabView()
    }
}
