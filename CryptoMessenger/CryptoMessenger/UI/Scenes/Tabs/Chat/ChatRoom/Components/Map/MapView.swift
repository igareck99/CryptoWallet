import MapKit
import SwiftUI

// MARK: - MapView

struct MapView: View {

    // MARK: - Internal Properties

    @Binding var showLocationTransition: Bool
    @State private var showShareView = false

    // MARK: - Private Properties

    private let isInteractionModesDisabled: Bool
    @StateObject var viewModel: MapViewModel

    // MARK: - Lifecycle

    init(place: Place, _ isInteractionModesDisabled: Bool = false,
         showLocationTransition: Binding<Bool>) {
        self.isInteractionModesDisabled = isInteractionModesDisabled
        self._viewModel = StateObject(wrappedValue: MapViewModel(place: place))
        self._showLocationTransition = showLocationTransition
    }

    // MARK: - Body

    var body: some View {
        ZStack {
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
            .onTapGesture {
                showLocationTransition = false
            }
            if showLocationTransition {
                AnotherAppTransitionView(showLocationTransition: $showLocationTransition,
                                         viewModel: AnotherApppTransitionViewModel(place: viewModel.place))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
