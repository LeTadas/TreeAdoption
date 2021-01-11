import MapKit
import SDWebImageSwiftUI
import SwiftUI

struct TreeDetailsView: View {
    @ObservedObject var viewModel: TreeDetailsViewModel

    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            switch viewModel.state {
                case .loading:
                    DefaultLoadingView()
                case let .loaded(result):
                    TreeDetailsScrollView(
                        item: result,
                        treePinLocation: viewModel.treePinLocation,
                        graphData: viewModel.graphData,
                        treeRegion: $viewModel.treeRegion,
                        onMapPressed: viewModel.showMap
                    )
                case .error:
                    DefaultErrorView(
                        titleKey: "news_view_network_error_title",
                        messageKey: "news_view_network_error_message"
                    )
            }
        }
        .navigationBarTitle(viewModel.treeName, displayMode: .large)
        .navigationBarItems(
            trailing:
            HStack {
                Button(action: viewModel.showTimeline) {
                    Image(systemName: "timeline.selection")
                }
                Button(action: viewModel.showBookATour) {
                    Image(systemName: "ticket")
                }
                Button(action: actionSheet) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        )
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .sheet(isPresented: $viewModel.sheetVisible) {
            switch viewModel.sheetView {
                case .timeline:
                    TimelineView(
                        viewModel: TimelineViewModel(FakeTimelineProvider()),
                        isPresented: $viewModel.sheetVisible
                    )
                case .bookATour:
                    ScheduleVisitView(isPresented: $viewModel.sheetVisible)
                case .viewMap:
                    NavigationView {
                        ViewOnMapView(
                            markers: viewModel.treePinLocation,
                            coordinateRegion: MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: 52.083690,
                                    longitude: 4.329780
                                ),
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.2,
                                    longitudeDelta: 0.2
                                )
                            )
                        )
                        .navigationBarItems(
                            trailing: Button("my_visits_view_done_button_title") {
                                viewModel.sheetVisible.toggle()
                            }
                        )
                    }
            }
        }
    }

    func actionSheet() {
        let items = [viewModel.treeName]
        let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct TreeDetailsScrollView: View {
    let item: TreeDetails
    let treePinLocation: [ViewOnMapMarker]
    let graphData: GraphData
    @Binding var treeRegion: MKCoordinateRegion
    let onMapPressed: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                GalleryView(
                    mainImageUrl: item.treeImageUrls.first!,
                    imageCount: item.treeImageUrls.count
                )
                LocationView(
                    coordinates: $treeRegion,
                    pinLocations: treePinLocation,
                    onPressed: onMapPressed
                )
                .padding(.top, 16)
                AnimalsDetectedView(animals: item.animalsDetected)
                HealthConditionView(treeHealth: item.treeHealth)
                    .padding(.top, 16)
                CarbonDioxideGraphView(graphData: graphData)
                    .padding(.top, 16)
                HStack {
                    TemperatureView(temperature: item.temperature)
                    HumidityView(humidity: item.humidity)
                }
                .padding(.top, 16)
                Text(formatContractEndsAt())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .padding(.bottom, 50)
                Spacer()
            }
            .padding(24)
        }
    }

    private func formatContractEndsAt() -> String {
        let formatter = DateFormatter.yearMonthDayDateTime

        return String(
            format: NSLocalizedString(
                "tree_details_view_adoption_contract_ends_label",
                comment: ""
            ),
            formatter.string(from: item.contractEndsAt)
        )
    }
}

struct GalleryView: View {
    let mainImageUrl: String
    let imageCount: Int

    var body: some View {
        VStack(spacing: 0) {
            CardTitleView(titleKey: "tree_details_view_gallery_label")
            ZStack(alignment: .bottomTrailing) {
                WebImage(
                    url: URL(
                        string: mainImageUrl
                    )
                )
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.primaryGray)
                }
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .clipped()
                .cornerRadius(10)
                .transition(.fade(duration: 0.5))
                .padding(.top, 16)
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color.white.opacity(0.8))
                    Text("\(imageCount)")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(Color.textPrimary)
                }
                .frame(width: 40, height: 40)
                .padding(8)
            }
        }
        .padding(16)
        .background(CardBackground())
    }
}

struct LocationView: View {
    @Binding var coordinates: MKCoordinateRegion
    let pinLocations: [ViewOnMapMarker]
    let onPressed: () -> Void

    var body: some View {
        VStack {
            CardTitleView(titleKey: "tree_details_view_tree_location_label")
            Map(
                coordinateRegion: $coordinates,
                interactionModes: .zoom,
                annotationItems: pinLocations
            ) { item in
                MapPin(coordinate: item.coordinate)
            }
            .cornerRadius(10)
        }
        .padding(16)
        .background(CardBackground())
        .frame(maxWidth: .infinity, maxHeight: 150)
        .onTapGesture {
            onPressed()
        }
    }
}

struct AnimalsDetectedView: View {
    let animals: [Animal]

    var body: some View {
        VStack(spacing: 16) {
            CardTitleView(titleKey: "tree_details_view_animals_detected_label")
            Text("tree_details_view_animals_detected_description_label")
                .font(.system(size: 14, weight: .regular))
                .lineLimit(3)
                .foregroundColor(Color.primaryGray)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            LazyHStack {
                ForEach(animals, id: \.type) { item in
                    AnimalIconView(iconName: mapAnimalIcon(item))
                }
            }
            .frame(height: 30)
        }
        .padding(16)
        .background(CardBackground())
        .padding(.top, 16)
    }

    private func mapAnimalIcon(_ animal: Animal) -> String {
        switch animal.type {
            case 0:
                return "ic_pig"
            case 1:
                return "ic_fox"
            case 2:
                return "ic_hatchog"
            case 3:
                return "ic_snake"
            case 4:
                return "ic_rat"
            default:
                fatalError("Unknown animal type")
        }
    }
}

struct HealthConditionView: View {
    let treeHealth: TreeHealth

    var body: some View {
        VStack(spacing: 0) {
            CardTitleView(titleKey: "tree_details_view_health_condition_label")
            Text(treeHealth.condition)
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(
                    SeverityColorProvider.severityColor(treeHealth.severityFraction)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            CardTitleView(titleKey: "tree_details_view_health_condition_severity_label")
                .padding(.top, 16)
            HealthProgressView(severityFraction: treeHealth.severityFraction)
                .padding(.top, 8)
            Text(formatLastUpdatedAt())
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color.primaryGray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 32)
        }
        .padding(16)
        .background(CardBackground())
    }

    private func formatLastUpdatedAt() -> String {
        let formatter = DateFormatter.yearMonthDayDateTime

        return String(
            format: NSLocalizedString(
                "tree_details_view_health_condition_last_updated_at",
                comment: ""
            ),
            formatter.string(from: treeHealth.updatedAt)
        )
    }
}

struct CarbonDioxideGraphView: View {
    let graphData: GraphData

    var body: some View {
        VStack {
            CardTitleView(titleKey: "tree_details_view_carbon_dioxide_view_label")
            VStack {
                VStack {
                    ZStack {
                        VStack {
                            GraphAmountIndicatorView(amount: graphData.yLabels[0])
                            Spacer()
                            GraphAmountIndicatorView(amount: graphData.yLabels[1])
                            Spacer()
                            GraphAmountIndicatorView(amount: graphData.yLabels[2])
                            Spacer()
                            GraphAmountIndicatorView(amount: graphData.yLabels[3])
                        }
                        GeometryReader { value in
                            GraphView(
                                data: graphData.dataPoints
                            )
                            .frame(
                                width: value.size.width,
                                height: value.size.height
                            )
                        }
                        .padding(.leading, 32)
                        .padding(.trailing, 8)
                    }
                    HStack {
                        GraphMonthIndicatorView(label: graphData.xLabels[0])
                        Spacer()
                        GraphMonthIndicatorView(label: graphData.xLabels[1])
                        Spacer()
                        GraphMonthIndicatorView(label: graphData.xLabels[2])
                        Spacer()
                        GraphMonthIndicatorView(label: graphData.xLabels[3])
                    }
                    .padding(.leading, 24)
                    .padding(.top, 8)
                }
            }
            .padding(.top, 16)
        }
        .padding(16)
        .background(CardBackground())
    }
}

struct TemperatureView: View {
    let temperature: Double

    var body: some View {
        VStack(alignment: .center) {
            CardTitleView(titleKey: "tree_details_view_temperature_label")
            Text(TemperatureFormatter.format(temperature: temperature))
                .font(.system(size: 48, weight: .heavy))
                .foregroundColor(.textPrimary)
        }
        .padding(16)
        .background(CardBackground())
    }
}

struct HumidityView: View {
    let humidity: Double

    var body: some View {
        VStack(alignment: .center) {
            CardTitleView(titleKey: "tree_details_view_humidity_label")
            Text(HumidityFormatter.format(humidity: humidity))
                .font(.system(size: 48, weight: .heavy))
                .foregroundColor(.textPrimary)
        }
        .padding(16)
        .background(CardBackground())
    }
}

struct GraphAmountIndicatorView: View {
    let amount: GraphAmount

    var body: some View {
        HStack(spacing: 8) {
            Text("\(formattedAmount()) g")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.primaryGray)
            Rectangle()
                .fill(Color.backgroundGray)
                .frame(maxWidth: .infinity, maxHeight: 1)
        }
    }

    private func formattedAmount() -> String {
        return String(format: "%.1f", amount.amount)
    }
}

struct GraphMonthIndicatorView: View {
    let label: GraphLabel

    var body: some View {
        Text(label.label)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(label.isCurrent ? .primaryColor : .primaryGray)
    }
}

struct HealthProgressView: View {
    let severityFraction: Double

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.backgroundGray)
                .frame(width: geometry.size.width, height: 18)
                .cornerRadius(10)
            Rectangle()
                .fill(
                    SeverityColorProvider.severityColor(severityFraction)
                )
                .frame(width: geometry.size.width * CGFloat(severityFraction), height: 18)
                .cornerRadius(10)
        }
    }
}

struct AnimalIconView: View {
    let iconName: String

    var body: some View {
        Image(iconName)
            .resizable()
            .frame(width: 30, height: 30)
    }
}

struct CardTitleView: View {
    let titleKey: LocalizedStringKey

    var body: some View {
        Text(titleKey)
            .font(.system(size: 16, weight: .heavy))
            .foregroundColor(Color.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TreeDetailsScene_Previews: PreviewProvider {
    static var previews: some View {
        TreeDetailsView(viewModel: TreeDetailsViewModel(12, DefaultTreeDetailsProvider(WebTreeService(), WebTelemetryService()), "White oak"))
    }
}
