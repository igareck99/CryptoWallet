import SwiftUI

protocol ChatHistoryFlowStateProtocol: ObservableObject {
    
}

class ChatHistoryFlowState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedItem: ChatHistorySheetLink?
    @Published var coverItem: ChatHistoryContentLink?
    @Published var selectedLink: ChatHistoryContentLink? // old style
}
