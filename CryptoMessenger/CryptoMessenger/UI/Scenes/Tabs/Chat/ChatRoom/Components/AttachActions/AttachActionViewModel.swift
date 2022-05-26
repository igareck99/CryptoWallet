import SwiftUI

// MARK: - AttachActionViewModel

final class AttachActionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var isTransactionAvailable = false
    @Injectable private(set) var togglesFacade: MainFlowTogglesFacade

    // MARK: - Lifecycle

    init() {
        fetchChatData()
    }

    // MARK: - Private Methods

    private func fetchChatData() {
        isTransactionAvailable = togglesFacade.isTransactionAvailable
    }
}
