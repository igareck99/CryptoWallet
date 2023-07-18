import SwiftUI

// MARK: - ChatHistoryCoordinatorBase

protocol ChatHistoryCoordinatorBase: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: ChatHistorySheetLink? { get set }
    var coverItem: ChatHistoryContentLink? { get set }
}

// MARK: - ChatHistoryFlowState

final class ChatHistoryFlowState: ChatHistoryCoordinatorBase {
    static var shared = ChatHistoryFlowState()
    @Published var path = NavigationPath()
    @Published var presentedItem: ChatHistorySheetLink?
    @Published var coverItem: ChatHistoryContentLink?
}
