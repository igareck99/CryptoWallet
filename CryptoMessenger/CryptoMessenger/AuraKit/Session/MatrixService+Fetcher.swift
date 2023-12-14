import Foundation
import MatrixSDK

extension MatrixService {

	func configureFetcher() {
        debugPrint("MATRIX DEBUG MatrixService configureFetcher")
		let sortOptions = MXRoomListDataSortOptions(
			missedNotificationsFirst: true,
			unreadMessagesFirst: true
		)
		let filterOptions = MXRoomListDataFilterOptions(showAllRoomsInHomeSpace: true)

		let roomListDataFetchOptions = MXRoomListDataFetchOptions(
			filterOptions: filterOptions,
			sortOptions: sortOptions
		)
		roomListDataFetcher = session?.roomListDataManager?.fetcher(withOptions: roomListDataFetchOptions)
		roomListDataFetcher?.addDelegate(self)
		roomListDataFetcher?.refresh()
	}

}

// MARK: - MXRoomListDataFetcherDelegate

extension MatrixService: MXRoomListDataFetcherDelegate {

	func fetcherDidChangeData(
		_ fetcher: MXRoomListDataFetcher,
		totalCountsChanged: Bool
	) {
		debugPrint("MATRIX DEBUG MatrixService fetcherDidChangeData")
		debugPrint("fetcher: \(String(describing: fetcher.data))")
	}
}
