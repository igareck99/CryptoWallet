import SwiftUI

// MARK: - ChatView

struct ChatView<ViewModel>: View where ViewModel: ChatViewModelProtocol {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @StateObject private var keyboardHandler = KeyboardHandler()

    // MARK: - Body

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                List {
                    ForEach(viewModel.displayItems, id: \.id) { item in
                        item.view()
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                    ForEach(viewModel.sendingEventsView, id: \.id) { item in
                        item.view()
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.inset)
                .onAppear {
                    viewModel.eventSubject.send(.onAppear)
                }
                .onReceive(viewModel.scrollIdPublisher, perform: { value in
                    withAnimation {
                        scrollView.scrollTo(value, anchor: .bottom)
                    }
                })
            }
            Spacer()
            inputView
        }
        .onTapGesture {
            hideKeyboard()
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.visible, for: .navigationBar)
    }

    private var inputView: some View {
        ChatInputViewModel(isWriteEnable: $viewModel.isAccessToWrite,
                           inputText: $viewModel.inputText,
                           activeEditMessage: $viewModel.activeEditMessage,
                           quickAction: $viewModel.quickAction) {
            viewModel.sendMessage(.text, image: nil, url: nil,
                                  record: nil, location: nil, contact: nil)
        } onChatRoomMenu: {
            viewModel.showChatRoomMenu()
        } sendAudio: { record in
            viewModel.sendMessage(.audio, image: nil, url: nil,
                                  record: record, location: nil, contact: nil)
        }
        .view()
    }
}
