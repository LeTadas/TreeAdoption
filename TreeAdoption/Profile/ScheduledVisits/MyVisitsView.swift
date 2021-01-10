import SwiftUI

struct MyVisitsView: View {
    @ObservedObject var viewModel = MyVisitsViewModel(
        DefaultBookedTourProvider(
            WebUserService(),
            WebTourService(),
            WebForestService()
        ),
        WebBookTourService()
    )

    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            switch viewModel.state {
                case .loading:
                    DefaultLoadingView()
                case let .loaded(items):
                    if items.isEmpty {
                        DefaultEmptyView(
                            imageSystemName: "calendar.badge.clock",
                            message: "my_visits_view_no_visits_message"
                        )
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(items, id: \.id) { item in
                                    BookedTourView(
                                        item: item,
                                        viewOnMapPressed: viewModel.viewOnMapPressed,
                                        cancelPressed: viewModel.cancelPressed
                                    )
                                }
                            }
                            .padding(24)
                        }
                    }
                case .error:
                    DefaultErrorView(
                        titleKey: "my_visits_view_network_error_title",
                        messageKey: "my_visits_view_network_error_description"
                    )
            }
        }
        .navigationBarTitle("my_visits_view_title", displayMode: .large)
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .alert(isPresented: $viewModel.alertVisible) {
            Alert(
                title: Text("my_visits_view_cancel_alert_title"),
                message: Text("my_visits_view_cancel_alert_message"),
                primaryButton: .destructive(
                    Text("my_visits_view_cancel_alert_primary_button_title"),
                    action: viewModel.onCancelApproved
                ),
                secondaryButton: .cancel(
                    Text("my_visits_view_cancel_alert_secondary_button_title"),
                    action: viewModel.onCancelDismissed
                )
            )
        }
        .sheet(isPresented: $viewModel.viewOnMapVisible) {
            NavigationView {
                ViewOnMapView(
                    markers: [viewModel.viewOnMapMarker!]
                )
                .navigationBarItems(
                    trailing: Button("my_visits_view_done_button_title") {
                        viewModel.viewOnMapVisible.toggle()
                        viewModel.viewOnMapMarker = nil
                    }
                )
            }
        }
    }
}
