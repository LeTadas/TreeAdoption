import SwiftUI

struct NewsDetailsView: View {
    @ObservedObject var viewModel: NewsDetailsViewModel

    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            switch viewModel.state {
                case .loading:
                    DefaultLoadingView()
                case let .loaded(result):
                    NewsDetailsScrollView(item: result)
                case .error:
                    DefaultErrorView(
                        titleKey: "news_details_view_network_error_title",
                        messageKey: "news_details_view_network_error_description"
                    )
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct NewsDetailsScrollView: View {
    let item: NewsItem

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(item.title)
                    .lineLimit(3)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(formatDate(date: item.createdAt))
                    .font(.system(size: 12, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primaryGray)
                    .padding(.top, 8)
                Text(item.content)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 16)
            }
            .padding(24)
        }
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct NewsDetailsViewPreviews: PreviewProvider {
    static var previews: some View {
        NewsDetailsView(viewModel: NewsDetailsViewModel(FakeNewsDetailsProvider(), "1"))
    }
}
