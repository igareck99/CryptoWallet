import SwiftUI

protocol ChatHistoryFlowStateProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: ChatHistorySheetLink? { get set }
    var coverItem: ChatHistoryContentLink? { get set }
    var selectedLink: ChatHistoryContentLink? { get set }
}

final class ChatHistoryFlowState: ChatHistoryFlowStateProtocol {
    @Published var path = NavigationPath()
    @Published var presentedItem: ChatHistorySheetLink?
    @Published var coverItem: ChatHistoryContentLink?
    @Published var selectedLink: ChatHistoryContentLink? // old style
}
