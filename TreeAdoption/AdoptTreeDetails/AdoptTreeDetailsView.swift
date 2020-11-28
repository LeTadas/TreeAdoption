import SwiftUI

struct AdoptTreeDetailsView: View {
    @ObservedObject var viewModel = AdoptTreeDetailsViewModel()

    @Binding var isPresented: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundGray
                .ignoresSafeArea()
            switch viewModel.state {
                case .loading:
                    DefaultLoadingView()
                case let .loaded(details):
                    DetailsView(item: details)
                case .error:
                    DefaultErrorView(
                        titleKey: "adopt_tree_details_view_network_error_title",
                        messageKey: "adopt_tree_details_view_network_error_message"
                    )
            }
            DefaultButton(
                titleKey: "adopt_tree_details_view_adopt_button_label",
                action: viewModel.adoptThisTreePressed
            )
            .padding(.bottom, 24)
        }
        .navigationBarTitle("adopt_tree_details_view_title", displayMode: .inline)
        .navigationBarItems(
            trailing: NavigationTextButton(
                action: { isPresented.toggle() },
                titleKey: "adopt_tree_details_view_done_button_label"
            )
        )
    }
}

struct DetailsView: View {
    let item: AdoptTreeDetails

    var body: some View {
        VStack(spacing: 0) {
            Text(item.name)
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(.textPrimary)
                .lineLimit(2)
            Text(formatCurrency())
                .font(.system(size: 18, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primaryGray)
                .padding(.top, 8)
            DescriptionView(
                labelKey: "adopt_tree_details_view_description_label",
                description: item.description
            )
            .padding(.top, 24)
            InfoCardView(
                labelKey: "adopt_tree_details_view_stock_label",
                description: "\(item.stock)"
            )
            .padding(.top, 24)
            Spacer()
        }
        .padding(24)
    }

    private func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.numberStyle = .currency
        let formattedAmount = formatter.string(from: item.price as NSNumber)

        guard let amount = formattedAmount else {
            return "-"
        }

        return String(
            format: NSLocalizedString(
                "adopt_tree_details_view_price_label",
                comment: ""
            ),
            amount
        )
    }
}

struct DescriptionView: View {
    let labelKey: LocalizedStringKey
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            Text(labelKey)
                .font(.system(size: 16, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            Text(description)
                .font(.system(size: 14, weight: .regular))
                .lineLimit(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
                .padding(.leading, 16)
                .padding(.trailing, 16)
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct InfoCardView: View {
    let labelKey: LocalizedStringKey
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            Text(labelKey)
                .font(.system(size: 16, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            Text(description)
                .font(.system(size: 30, weight: .heavy))
                .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct AdoptTreeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptTreeDetailsView(isPresented: .constant(true))
    }
}
