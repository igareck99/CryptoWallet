import SwiftUI

protocol ChatCreateFlowStateProtocol: ObservableObject {
    
}

class ChatCreateFlowState: ChatHistoryCoordinatorBase {
    static let shared = ChatCreateFlowState()
}
