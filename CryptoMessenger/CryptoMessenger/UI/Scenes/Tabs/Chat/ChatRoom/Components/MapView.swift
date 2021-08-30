import MapKit
import SwiftUI

struct Place: Identifiable {
    let id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {
    let place: Place

    @State private var region: MKCoordinateRegion

    init(place: Place) {
        self.place = place
        region = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 650, longitudinalMeters: 650)
    }

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: [place]) { place in
            MapAnnotation(
                coordinate: place.coordinate,
                anchorPoint: CGPoint(x: 0.5, y: 1)
            ) {
                Image(R.image.chat.location.marker.name)
            }
        }
    }
}
