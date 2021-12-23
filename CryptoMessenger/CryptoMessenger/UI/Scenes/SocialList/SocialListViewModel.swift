import SwiftUI

// MARK: - SocialListViewModel

final class SocialListViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var listData = SocialListItem.socialList()

    // MARK: - Internal Methods

    func onMove(source: IndexSet, destination: Int) {
        listData.move(fromOffsets: source, toOffset: destination)
    }
    
    func remove(offsets: IndexSet) {
        listData.remove(atOffsets: offsets)
    }

    func getLastShow() -> Int {
        return listData.lastIndex { item in
            item.type == .show
        } ?? -1
    }
}
