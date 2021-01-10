import MapKit
import SwiftUI

struct ViewOnMapView: View {
    let markers: [ViewOnMapMarker]

    @State var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.136395, longitude: 4.338723),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    var body: some View {
        Map(
            coordinateRegion: $coordinateRegion,
            annotationItems: markers
        ) { place in
            MapMarker(coordinate: place.coordinate, tint: .green)
        }
        .ignoresSafeArea()
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

struct ViewOnMapView_Previews: PreviewProvider {
    static var previews: some View {
        ViewOnMapView(
            markers: [
                ViewOnMapMarker(
                    latitude: 52.136395,
                    longitude: 4.338723
                )
            ]
        )
    }
}

struct ViewOnMapMarker: Identifiable {
    var id = UUID()
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
