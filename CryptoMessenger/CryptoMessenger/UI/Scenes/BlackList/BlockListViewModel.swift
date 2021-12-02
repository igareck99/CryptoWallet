import SwiftUI

// MARK: - BlockListViewModel

final class BlockListViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var listData = BlockedUserItem.blockedUsers()

    // MARK: - Internal Methods

    func reload() {
        listData = BlockedUserItem.blockedUsers()
    }
}