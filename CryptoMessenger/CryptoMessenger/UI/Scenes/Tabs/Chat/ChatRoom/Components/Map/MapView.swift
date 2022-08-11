import MapKit
import SwiftUI

// MARK: - MapView

struct MapView: View {
    // MARK: - Private Properties

    private let isInteractionModesDisabled: Bool
    private(set) var viewModel: MapViewModel

    // MARK: - Lifecycle

    init(place: Place, _ isInteractionModesDisabled: Bool = false) {
        self.isInteractionModesDisabled = isInteractionModesDisabled
        self.viewModel = MapViewModel(place: place)
    }

    // MARK: - Body

    var body: some View {
        Map(
            coordinateRegion: viewModel.$region,
            interactionModes: isInteractionModesDisabled ? [] : .all,
            showsUserLocation: false,
            annotationItems: [viewModel.place]
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
