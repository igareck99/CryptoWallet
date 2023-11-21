import SwiftUI

// MARK: - ChatHistoryCoordinatorBase

protocol ChatHistoryCoordinatorBase: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: BaseSheetLink? { get set }
    var coverItem: BaseFullCoverLink? { get set }
    var sheetHeight: CGFloat { get set }
}

// MARK: - ChatHistoryFlowState

final class ChatHistoryFlowState: ChatHistoryCoordinatorBase {

    static var shared = ChatHistoryFlowState()
    @Published var path = NavigationPath()
    @Published var presentedItem: BaseSheetLink?
    @Published var coverItem: BaseFullCoverLink?
    @Published var sheetHeight: CGFloat = 223
}
