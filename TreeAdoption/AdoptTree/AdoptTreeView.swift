import SwiftUI

struct AdoptTreeView: View {
    @ObservedObject var viewModel = AdoptTreeViewModel()
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                    .ignoresSafeArea()
                switch viewModel.state {
                    case .loading:
                        DefaultLoadingView()
                    case let .loaded(items):
                        AdoptTreeList(items: items)
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
        }
    }
}

struct AdoptTreeList: View {
    let items: [AdoptTreeItem]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    AdoptTreeViewItem(item: item)
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
            HStack {
                Image("ic_tree")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipped()
                    .cornerRadius(20)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .lineLimit(1)
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.textPrimary)
                    Text(item.description)
                        .lineLimit(2)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.textPrimary)
                }
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
}

struct AdoptTreeView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptTreeView(isPresented: .constant(true))
    }
}
