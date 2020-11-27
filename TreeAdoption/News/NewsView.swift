import SwiftUI

struct NewsView: View {
    @ObservedObject var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                switch viewModel.newsState {
                    case .loading:
                        DefaultLoadingView()
                    case let .loaded(items):
                        NewsListView(items: items)
                    case .empty:
                        DefaultEmptyView(
                            imageSystemName: "newspaper",
                            message: "news_view_no_news_message"
                        )
                    case .error:
                        DefaultErrorView(
                            titleKey: "news_view_network_error_title",
                            messageKey: "news_view_network_error_message"
                        )
                }
            }
            .navigationBarTitle("news_view_title", displayMode: .inline)
        }
    }
}

struct NewsListView: View {
    let items: [NewsItem]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    NewsViewItem(item: item)
                }
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
        }
    }
}

struct NewsViewItem: View {
    let item: NewsItem

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .lineLimit(2)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.content)
                    .lineLimit(5)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.primaryGray)
                    Text(formatDate(date: item.createdAt))
                        .lineLimit(1)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primaryGray)
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

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
