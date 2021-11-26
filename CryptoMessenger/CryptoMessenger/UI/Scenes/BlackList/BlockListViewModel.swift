import SwiftUI

// MARK: - BlockListViewModel

class BlockListViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var listData = BlockedUserItem.blockedUsers()

    // MARK: - Internal Methods

    func reload() {
        listData = BlockedUserItem.blockedUsers()
    }
}
