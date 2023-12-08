import SwiftUI

// MARK: - ChatCreateFlowStateProtocol

protocol ChatCreateFlowStateProtocol: ObservableObject {
    var createPath: NavigationPath { get set }
    var presentedItem: BaseSheetLink? { get set }
}

// MARK: - ChatCreateFlowState

class ChatCreateFlowState: ChatCreateFlowStateProtocol {
    @Published var createPath = NavigationPath()
    @Published var presentedItem: BaseSheetLink?
    static let shared = ChatCreateFlowState()
}
