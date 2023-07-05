import SwiftUI

protocol ChatCreateFlowStateProtocol: ObservableObject {
    
}

class ChatCreateFlowState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedItem: ChatHistoryContentLink?
    @Published var coverItem: ChatHistoryContentLink?
    @Published var selectedLink: ChatHistoryContentLink? // old style
}
