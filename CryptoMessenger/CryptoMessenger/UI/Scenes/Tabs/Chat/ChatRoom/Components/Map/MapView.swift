import MapKit
import SwiftUI

// MARK: - Place

struct Place: Identifiable {

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
}

// MARK: - MapView

struct MapView: View {

    // MARK: - Private Properties

    @State private var region: MKCoordinateRegion
    private let place: Place
    private let isInteractionModesDisabled: Bool

    // MARK: - Lifecycle

    init(place: Place, _ isInteractionModesDisabled: Bool = false) {
        region = MKCoordinateRegion(
            center: .init(latitude: place.latitude, longitude: place.longitude),
            latitudinalMeters: 650,
            longitudinalMeters: 650
        )
        self.place = place
        self.isInteractionModesDisabled = isInteractionModesDisabled
    }

    // MARK: - Body

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: isInteractionModesDisabled ? [] : .all,
            showsUserLocation: false,
            annotationItems: [place]
        ) { place in
            MapAnnotation(
                coordinate: .init(latitude: place.latitude, longitude: place.longitude),
                anchorPoint: CGPoint(x: 0.5, y: 0.5)
            ) {
                R.image.chat.location.marker.image
            }
        }
    }
}
