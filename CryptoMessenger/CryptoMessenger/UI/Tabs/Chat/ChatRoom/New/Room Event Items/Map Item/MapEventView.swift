import MapKit
import SwiftUI

struct MapEventView<EventData: View>: View {
    var model: MapEvent {
        didSet {
            viewModel.update(place: model.place)
        }
    }
    let eventData: EventData
    @StateObject var viewModel = MapEventViewModel()

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region,
                interactionModes: .all,
                showsUserLocation: false,
                annotationItems: [viewModel.place]
            ) { place in
                MapAnnotation(
                    coordinate: .init(latitude: place.latitude, longitude: place.longitude),
                    anchorPoint: CGPoint(x: 0.1, y: 0.1)
                ) {
                    R.image.chat.location.marker.image
                }
            }
            .frame(width: 247, height: 142)
            .onTapGesture {
                model.onTap()
            }
            .overlay(alignment: .bottomTrailing) {
                eventData
            }
        }
        .frame(width: 247, height: 142)
    }
}
