import SwiftUI

struct AdoptTreeView: View {
    @ObservedObject var viewModel = AdoptTreeViewModel(
        DefaultAvailableTreesForAdoptionProvider(NetworkClient())
    )

    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        UINavigationBar.appearance().tintColor = UIColor(named: "primaryColor")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                    .ignoresSafeArea()
                switch viewModel.state {
                    case .loading:
                        DefaultLoadingView()
                    case let .loaded(items):
                        if items.isEmpty {
                            DefaultEmptyView(
                                imageSystemName: "magnifyingglass",
                                message: "adopt_tree_view_no_trees_found_message"
                            )
                        } else {
                            AdoptTreeList(items: items, isPresented: $isPresented)
                        }
                    case .error:
                        DefaultErrorView(
                            titleKey: "adopt_tree_view_network_error_title",
                            messageKey: "adopt_tree_view_network_error_message"
                        )
                }
            }
            .navigationBarTitle("adopt_tree_view_title", displayMode: .inline)
            .navigationBarItems(
                trailing: NavigationTextButton(
                    action: { isPresented.toggle() },
                    titleKey: "adopt_tree_view_done_button_title"
                )
            )
            .onAppear(perform: viewModel.onAppear)
            .onDisappear(perform: viewModel.onDisappear)
        }
    }
}

struct AdoptTreeList: View {
    let items: [AdoptTreeItem]
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    NavigationLink(destination: AdoptTreeDetailsView(isPresented: $isPresented)) {
                        AdoptTreeViewItem(item: item)
                    }
                }
            }
            .padding(24)
            .padding(.bottom, 88)
        }
    }
}

struct AdoptTreeViewItem: View {
    let item: AdoptTreeItem

    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color.primaryColor)
                    getIconForCategory()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                .frame(width: 60, height: 60)
                .padding(.trailing, 16)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .lineLimit(1)
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.textPrimary)
                    Text(item.description)
                        .lineLimit(2)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.textPrimary)
                    Spacer()
                }
                Spacer()
            }
            .padding(16)
        }
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
        )
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    private func getIconForCategory() -> Image {
        return (item.category == 1) ? Image("ic_sapling") : Image("ic_mature_tree")
    }
}

struct AdoptTreeView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptTreeView(isPresented: .constant(true))
    }
}
