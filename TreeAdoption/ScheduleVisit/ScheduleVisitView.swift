import SwiftUI

struct ScheduleVisitView: View {
    @ObservedObject var viewModel = ScheduleVisitViewModel(
        DefaultTourProvider(WebTourService()),
        WebBookTourService()
    )
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.backgroundGray
                    .ignoresSafeArea()
                switch viewModel.state {
                    case .loading:
                        DefaultLoadingView()
                    case let .loaded(result):
                        ScheduleVisitScrollView(
                            items: result,
                            selectedItem: $viewModel.selectedVisit
                        )
                    case .error:
                        DefaultErrorView(
                            titleKey: "schedule_visit_view_network_error_title",
                            messageKey: "schedule_visit_view_network_error_description"
                        )
                }
                DefaultButton(
                    titleKey: "schedule_visit_view_schedule_button_title",
                    action: viewModel.scheduleVisit,
                    disabled: $viewModel.scheduleButtonsDisabled
                )
                .padding(.bottom, 24)
            }
            .navigationBarTitle("schedule_visit_view_title", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(
                    action: { isPresented = false }
                ) {
                    Text("schedule_visit_view_done_button_title")
                        .foregroundColor(.primaryColor)
                }
            )
            .onAppear(perform: viewModel.onAppear)
            .alert(isPresented: $viewModel.successVisible) {
                Alert(
                    title: Text("Success"),
                    message: Text("Successfully scheduled a visit"),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
}

struct ScheduleVisitScrollView: View {
    let items: [VisitItem]
    @Binding var selectedItem: VisitItem

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    VisitView(
                        item: item,
                        selected: item == selectedItem,
                        action: {
                            selectedItem = $0
                        }
                    )
                }
            }
            .padding(24)
        }
    }
}

struct VisitView: View {
    let item: VisitItem
    let selected: Bool
    let action: (VisitItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.title)
                .font(.system(size: 24, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {}) {
                HStack {
                    Image(systemName: "location.circle")
                        .foregroundColor(.primaryColor)
                    Text("schedule_visit_view_view_on_map_button_title")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primaryColor)
                }
            }
            .padding(.top, 16)
            HStack {
                Image(systemName: "calendar.circle")
                    .foregroundColor(.primaryGray)
                Text(formattedDate())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primaryGray)
            }
            .padding(.top, 8)
            HStack {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(.primaryGray)
                Text("schedule_visit_view_about_guide_title")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primaryGray)
            }
            .padding(.top, 8)
            Text(item.description)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .foregroundColor(.textPrimary)
                .padding(.top, 8)
        }
        .padding(16)
        .background(CardBackground())
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(selected ? Color.primaryColor : Color.clear, lineWidth: 2)
        )
        .padding(.top, 8)
        .padding(.bottom, 8)
        .onTapGesture {
            action(item)
        }
    }

    private func formattedDate() -> String {
        return DateFormatter.yearMonthDayDateTime.string(from: item.date)
    }
}

struct ScheduleVisitView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleVisitView(isPresented: .constant(false))
    }
}
