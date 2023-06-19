import Foundation
import SwiftUI

protocol ChatHistoryRouterable {
    
    func routeToFirstAction(_ room: AuraRoom)
    
    func routeToCreateChat(_ chatData: Binding<ChatData>)
}

struct ChatHistoryRouter<Content: View>: View {
    
    @ObservedObject var state = ChatHistoryFlowState()
    
    let content: () -> Content
    
    init(
        content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    var body: some View {
        NavigationStack(path: $state.path) {
            ZStack {
                content()
            }
            .navigationDestination(for: ChatHistoryContentLink.self,
                                   destination: linkDestination)
        }
    }

    @ViewBuilder
    private func linkDestination(link: ChatHistoryContentLink) -> some View {
        switch link {
        case let .firstLink(text):
            ChatRoomViewModelAssembl.build(text)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func sheetContent(item: ChatHistoryContentLink) -> some View {
        switch item {
        case let .createChat(chatData):
            ChatCreateView(chatData: chatData, viewModel: .init())
        default:
            EmptyView()
        }
    }
}

extension ChatHistoryRouter: ChatHistoryRouterable {
    func routeToFirstAction(_ room: AuraRoom) {
        state.path.append(ChatHistoryContentLink.firstLink(text: room))
    }
    
    func routeToCreateChat(_ chatData: Binding<ChatData>) {
        state.presentedItem = .createChat(chatData: chatData)
    }
}
