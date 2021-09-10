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
    @State private var region: MKCoordinateRegion

    private let place: Place
    private let isInteractionModesDisabled: Bool

    init(place: Place, _ isInteractionModesDisabled: Bool = false) {
        region = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 650, longitudinalMeters: 650)
        self.place = place
        self.isInteractionModesDisabled = isInteractionModesDisabled
    }

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: isInteractionModesDisabled ? [] : .all,
            showsUserLocation: false,
            annotationItems: [place]
        ) { place in
            MapAnnotation(
                coordinate: place.coordinate,
                anchorPoint: CGPoint(x: 0.5, y: 1)
            ) {
                R.image.chat.location.marker.image
            }
        }
    }
}
