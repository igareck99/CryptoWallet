import Foundation

// MARK: - DocumentsViewerViewModel

final class DocumentsViewerViewModel: ObservableObject {

    // MARK: - Internal Properties

    var isAnyFileAvailable: Bool {
        togglesFacade.isAnyFilesAvailable
    }

    // MARK: - Private Properties

    private let togglesFacade: ChatRoomTogglesFacadeProtocol

    // MARK: - Lifecycle

    init(togglesFacade: ChatRoomTogglesFacadeProtocol = ChatRoomViewModelAssembly.build()) {
        self.togglesFacade = togglesFacade
    }
}
