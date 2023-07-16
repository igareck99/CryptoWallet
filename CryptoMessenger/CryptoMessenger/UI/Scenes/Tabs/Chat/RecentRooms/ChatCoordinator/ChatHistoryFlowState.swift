import SwiftUI

// MARK: - ChatHistoryCoordinatorBase

class ChatHistoryCoordinatorBase: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedItem: ChatHistorySheetLink?
    @Published var coverItem: ChatHistoryContentLink?
}

// MARK: - ChatHistoryFlowState

final class ChatHistoryFlowState: ChatHistoryCoordinatorBase {
    static var shared = ChatHistoryFlowState()
}
