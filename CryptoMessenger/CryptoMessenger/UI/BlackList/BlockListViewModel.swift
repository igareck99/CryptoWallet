import SwiftUI

// MARK: - BlockListViewModel

final class BlockListViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var listData = BlockedUserItem.blockedUsers()
    let resources: BlockedUserResourcable.Type

    // MARK: - Internal Methods

    func reload() {
        listData = BlockedUserItem.blockedUsers()
    }
    
    init(
        resources: BlockedUserResourcable.Type = BlockedUserResources.self
    ) {
        self.resources = resources
    }
}
