import SwiftUI

// MARK: - ChatCreateFlowStateProtocol

protocol ChatCreateFlowStateProtocol: ObservableObject {
    var createPath: NavigationPath { get set }
    var presentedItem: ChatHistorySheetLink? { get set }
}

// MARK: - ChatCreateFlowState

class ChatCreateFlowState: ChatCreateFlowStateProtocol {
    @Published var createPath = NavigationPath()
    @Published var presentedItem: ChatHistorySheetLink?
    static let shared = ChatCreateFlowState()
}
