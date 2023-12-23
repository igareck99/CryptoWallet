import Combine
import SwiftUI

// MARK: - ChatHistoryView

struct ChatHistoryView<ViewModel: ChatHistoryViewDelegate>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @State private var chatData = ChatData()
    @State private var showReadAll = false

    // MARK: - Body

    var body: some View {
        content
            .hideKeyboardOnTap()
            .onAppear {
                viewModel.onAppear()
            }
    }

    // MARK: - Body Properties

    var content: some View {
        ChatSearchView(
            views: $viewModel.chatSections,
            viewState: $viewModel.viewState,
            isSearchingState: $viewModel.isSearching
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.visible, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbar {
            toolbarItems()
        }
        .searchable(
            text: $viewModel.searchText,
            prompt: "Поиск по чатам и каналам"
        )
        .confirmationDialog("", isPresented: $showReadAll) {
            Button(viewModel.resources.readAll, action: {
                viewModel.markAllAsRead()
            })
        }
    }

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack(spacing: 4) {
                Text(viewModel.resources.chats)
                    .multilineTextAlignment(.center)
                    .font(.bodySemibold17)
                    .foreground(viewModel.resources.titleColor)
                    .accessibilityAddTraits(.isHeader)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
                Button {
                    viewModel.eventSubject.send(.onCreateChat)
                } label: {
                    viewModel.resources.squareAndPencil
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .center)
                }
                Button(action: {
                    showReadAll.toggle()
                }, label: {
                    viewModel.resources.ellipsisCircle
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .center)
                })
            }
        }
    }
}
