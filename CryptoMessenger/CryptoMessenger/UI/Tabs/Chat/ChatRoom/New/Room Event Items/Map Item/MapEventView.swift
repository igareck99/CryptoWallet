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
            MapSnapshotView(
                latitude: model.place.latitude,
                longitude: model.place.longitude
            )
            .frame(width: 247, height: 142)
            .onTapGesture {
                model.onTap()
            }
            .overlay(alignment: .bottomTrailing) {
                eventData
                    .padding([.trailing, .bottom], 8)
            }
        }
        .frame(width: 247, height: 142)
    }
}
