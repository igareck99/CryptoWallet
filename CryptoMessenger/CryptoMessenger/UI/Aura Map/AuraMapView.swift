import MapKit
import SwiftUI

struct AuraMapView<ViewModel: AuraMapViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Map(
                coordinateRegion: $viewModel.region,
                interactionModes: viewModel.isInteractionModesDisabled ? [] : .all,
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
            .onTapGesture {
                viewModel.didTapAnnotation()
            }
            .navigationBarTitle(Text(R.string.localizable.chatGeoposition()))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                makeToolBar()
            }
        }
    }

    @ToolbarContentBuilder
    private func makeToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(R.string.localizable.contactChatDetailClose()) {
                presentationMode.wrappedValue.dismiss()
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(
                action: {
                    viewModel.didTapOpenPlaceInOtherApp()
                },
                label: {
                    Image(systemName: "arrowshape.turn.up.forward").opacity(.zero)
                }
            )
        }
    }
}
