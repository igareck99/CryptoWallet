import SwiftUI

struct ChatMapView: View {

	@Binding private var showMap: Bool
	@Binding private var showLocationTransition: Bool
	private let location: LocationData
	private let date: String
	private let isFromCurrentUser: Bool

	init(
		date: String,
		showMap: Binding<Bool>,
		showLocationTransition: Binding<Bool>,
		location: LocationData,
		isFromCurrentUser: Bool
	) {
		self.date = date
		self._showMap = showMap
		self._showLocationTransition = showLocationTransition
		self.location = location
		self.isFromCurrentUser = isFromCurrentUser
	}

    var body: some View {

		ZStack {
			MapSnapshotView(latitude: location.lat, longitude: location.long)
			CheckReadView(time: date, isFromCurrentUser: isFromCurrentUser)
		}
		.frame(width: 247, height: 142)
		.sheet(isPresented: $showMap) {
			NavigationView {
				MapView(place: .init(
					name: "",
					latitude: location.lat,
					longitude: location.long
				), showLocationTransition: $showLocationTransition)
				.ignoresSafeArea()
				.navigationBarTitle(Text(R.string.localizable.chatGeoposition()))
				.navigationBarItems(
					leading: Button(
						R.string.localizable.contactChatDetailClose(),
						action: { showMap.toggle() }
					),
					trailing: Button(
						action: { showLocationTransition = true },
						label: { Image(systemName: "arrowshape.turn.up.forward") }
					)
				)
				.navigationBarTitleDisplayMode(.inline)
				.navigationBarColor(.white())
			}
		}
		.onTapGesture {
			showMap.toggle()
		}
    }
}
