import SwiftUI

protocol ChatCreateFlowStateProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: ChatHistorySheetLink? { get set }

    func update(path: Binding<NavigationPath>)
    func update(presentedItem: Binding<ChatHistorySheetLink?>)
}

class ChatCreateFlowState: ChatCreateFlowStateProtocol {
    @Binding var path: NavigationPath
    @Binding var presentedItem: ChatHistorySheetLink?
    
    init(
        path: Binding<NavigationPath>,
        presentedItem: Binding<ChatHistorySheetLink?>
    ) {
        self._path = path
        self._presentedItem = presentedItem
    }
    
    func update(path: Binding<NavigationPath>) {
        _path = path
    }
    
    func update(presentedItem: Binding<ChatHistorySheetLink?>) {
        _presentedItem = presentedItem
    }
}
