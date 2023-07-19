import SwiftUI

protocol ChatCreateFlowStateProtocol: ObservableObject {
    
}

class ChatCreateFlowState: ChatCreateFlowStateProtocol {
    static let shared = ChatCreateFlowState()
}
