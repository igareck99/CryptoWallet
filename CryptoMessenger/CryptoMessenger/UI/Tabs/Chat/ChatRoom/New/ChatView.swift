import SwiftUI

// MARK: - ChatView

struct ChatView<ViewModel>: View where ViewModel: ChatViewModelProtocol {
    
    // MARK: - Internal Properties
    
    @StateObject var viewModel: ViewModel
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    // MARK: - Body

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.displayItems, id: \.hashValue) { item in
                    item.view()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
            Spacer()
            inputView
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.eventSubject.send(.onAppear)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.visible, for: .navigationBar)
    }

    private var inputView: some View {
        ChatInputViewModel(isWriteEnable: $viewModel.isAccessToWrite,
                           inputText: $viewModel.inputText,
                           activeEditMessage: $viewModel.activeEditMessage,
                           quickAction: $viewModel.quickAction) {
            viewModel.sendText()
        } onChatRoomMenu: {
            viewModel.showChatRoomMenu()
        } sendAudio: { record in
            viewModel.sendAudio(record)
        }
        .view()
    }
}
