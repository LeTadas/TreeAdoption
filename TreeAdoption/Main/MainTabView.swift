import SwiftUI

struct MainTabView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "primaryGray")
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
    }

    var body: some View {
        TabView {
            Text("FirstView")
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("main_tab_view_my_trees_label")
                }
            Text("SecondView")
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("main_tab_view_news_label")
                }
            Text("ThirdView")
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
