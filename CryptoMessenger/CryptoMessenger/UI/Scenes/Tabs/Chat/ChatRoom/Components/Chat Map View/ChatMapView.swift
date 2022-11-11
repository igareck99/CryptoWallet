import SwiftUI

struct ChatMapView: View {

	@Binding private var showMap: Bool
	@Binding private var showLocationTransition: Bool
	private let location: LocationData
	private let date: String
	private let isFromCurrentUser: Bool
	private let reactionItems: [ReactionTextsItem]
	@State private var totalHeight: CGFloat = .zero

	init(
		date: String,
		showMap: Binding<Bool>,
		showLocationTransition: Binding<Bool>,
		reactionItems: [ReactionTextsItem],
		location: LocationData,
		isFromCurrentUser: Bool
	) {
		self.date = date
		self._showMap = showMap
		self._showLocationTransition = showLocationTransition
		self.reactionItems = reactionItems
		self.location = location
		self.isFromCurrentUser = isFromCurrentUser
	}

    var body: some View {
		VStack(alignment: .trailing, spacing: 0) {
			ZStack {
				MapSnapshotView(
					latitude: location.lat,
					longitude: location.long
				)
				.cornerRadius(16)
				CheckReadView(time: date, isFromCurrentUser: isFromCurrentUser)
			}
			.frame(width: 238, height: 142)

			VStack(alignment: .trailing, spacing: 0) {
				ReactionsGrid(
					totalHeight: $totalHeight,
					viewModel: ReactionsGroupViewModel(items: reactionItems)
				)
				.frame(
					minHeight: totalHeight == 0 ? precalculateViewHeight(for: 238, itemsCount: reactionItems.count) : totalHeight
				)
			}
			.frame(width: 238)
			.padding(.top, 6)
			.padding([.bottom, .trailing, .leading], 8)
		}
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
