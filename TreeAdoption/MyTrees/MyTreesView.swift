import SDWebImageSwiftUI
import SwiftUI

struct MyTreesView: View {
    @ObservedObject var viewModel = MyTreesViewModel(
        DefaultMyTreeProvider(WebUserService(), WebTelemetryService())
    )

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.backgroundGray
                    .ignoresSafeArea()
                switch viewModel.state {
                    case .loading:
                        DefaultLoadingView()
                    case let .loaded(items):
                        if items.isEmpty {
                            NoTreesView()
                        } else {
                            TreeList(items: items)
                        }
                    case .error:
                        DefaultErrorView(
                            titleKey: "my_trees_view_network_error_title",
                            messageKey: "my_trees_view_network_error_message"
                        )
                }
                DefaultButton(
                    titleKey: "my_trees_view_adopt_button_title",
                    action: viewModel.adoptTreePressed,
                    disabled: .constant(false)
                )
                .padding(.bottom, 24)
            }
            .navigationBarTitle("my_trees_view_title", displayMode: .large)
            .onAppear(perform: viewModel.onAppear)
            .onDisappear(perform: viewModel.onDisappear)
            .onOpenURL(perform: viewModel.handleUrl)
            .sheet(isPresented: $viewModel.sheetVisible) {
                switch viewModel.sheet {
                    case .adoptTree:
                        AdoptTreeView(isPresented: $viewModel.sheetVisible)
                    case .paymentStatus:
                        NavigationView {
                            PaymentStatusView(
                                viewModel: PaymentStatusViewModel(WebOrderServiceProvider())
                            )
                            .navigationBarItems(trailing:
                                Button("payment_status_view_done_button_title") {
                                    viewModel.refresh()
                                    viewModel.sheetVisible.toggle()
                                }
                            )
                        }
                }
            }
        }
    }
}

struct NoTreesView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image("ic_tree")
                Text("my_trees_view_empty_state_label")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primaryGray)
                    .padding(.top, 32)
            }
            Spacer()
        }
    }
}

struct TreeList: View {
    let items: [TreeSummary]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    NavigationLink(
                        destination: TreeDetailsView(
                            viewModel: TreeDetailsViewModel(
                                item.id,
                                DefaultTreeDetailsProvider(
                                    WebTreeService(),
                                    WebTelemetryService()
                                ), item.name
                            )
                        )
                    ) {
                        TreeViewItem(item: item)
                    }
                }
            }
            .padding(24)
            .padding(.bottom, 88)
        }
    }
}

struct TreeViewItem: View {
    let item: TreeSummary

    var body: some View {
        ZStack {
            HStack {
                WebImage(url: URL(string: item.imageUrl))
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.primaryGray)
                    }
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipped()
                    .cornerRadius(20)
                    .transition(.fade(duration: 0.5))
                VStack(alignment: .leading) {
                    Text(item.name)
                        .lineLimit(1)
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    HStack {
                        MeasurementView(
                            iconName: "drop",
                            text: HumidityFormatter.format(humidity: item.humidity)
                        )
                        MeasurementView(
                            iconName: "thermometer.sun",
                            text: TemperatureFormatter.format(temperature: item.temperature)
                        )
                    }
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
}

struct MeasurementView: View {
    let iconName: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 22))
                .foregroundColor(.primaryGray)
            Text(text)
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.primaryGray)
        }
    }
}

struct MyTreesView_Previews: PreviewProvider {
    static var previews: some View {
        MyTreesView()
    }
}
