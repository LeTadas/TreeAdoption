import MapKit
import SwiftUI

struct BookedTourView: View {
    let item: VisitItem
    let viewOnMapPressed: (ViewOnMapMarker) -> Void
    let cancelPressed: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.system(size: 24, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    viewOnMapPressed(
                        ViewOnMapMarker(latitude: item.latitude, longitude: item.longitude)
                    )
                }) {
                    HStack {
                        Image(systemName: "location.circle")
                            .foregroundColor(.primaryColor)
                        Text("booked_tour_view_view_on_map_button_title")
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
                    Text("booked_tour_view_about_guide_title")
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
            Button(action: { cancelPressed(item.id) }) {
                Text("booked_tour_view_cancel_button_title")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 180, height: 30)
            .background(Color("primaryColor"))
            .cornerRadius(15)
            .padding(.top, 16)
        }
        .padding(16)
        .background(CardBackground(withShadow: true))
        .padding(.bottom, 24)
    }

    private func formattedDate() -> String {
        return DateFormatter.yearMonthDayDateTime.string(from: item.date)
    }
}

struct BookedTourViewPreviews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            BookedTourView(
                item: VisitItem(
                    id: 0,
                    title: "Guided visit (English)",
                    latitude: 52.083690,
                    longitude: 4.329780,
                    date: Date(),
                    description:
                    """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent cursus sapien at aliquam placerat. Nulla tortor risus, commodo eu quam ut, eleifend molestie dolor. Suspendisse mollis velit arcu, id tempor velit varius a. Vivamus interdum quis nulla sit amet faucibus. Vivamus imperdiet fringilla justo, ac aliquam neque. Morbi id sollicitudin leo, ac sagittis urna. Nam tincidunt tortor vel odio pharetra, at vulputate sapien tristique.
                    """
                ),
                viewOnMapPressed: { _ in },
                cancelPressed: { _ in }
            )
        }
        .previewLayout(.fixed(width: 300, height: 400))
    }
}
