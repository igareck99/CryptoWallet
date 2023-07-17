import SwiftUI

protocol ChatHistoryFlowStateProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: ChatHistorySheetLink? { get set }
    var coverItem: ChatHistoryContentLink? { get set }
}

final class ChatHistoryFlowState: ChatHistoryFlowStateProtocol {
    static var shared = ChatHistoryFlowState()
    @Published var path = NavigationPath()
    @Published var presentedItem: ChatHistorySheetLink?
    @Published var coverItem: ChatHistoryContentLink?
}
