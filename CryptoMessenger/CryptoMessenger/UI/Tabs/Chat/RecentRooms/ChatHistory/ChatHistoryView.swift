import Combine
import SwiftUI

// MARK: - ChatHistoryView

struct ChatHistoryView<ViewModel>: View where ViewModel: ChatHistoryViewDelegate {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @State private var chatData = ChatData()
    @State private var showReadAll = false

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.onAppear()
            }
    }

    // MARK: - Body Properties

    var content: some View {
        ChatSearchView(views: $viewModel.chatSections,
                       viewState: $viewModel.viewState,
                       isSearchingState: $viewModel.isSearching)
            .searchable(text: $viewModel.searchText)
            .confirmationDialog("", isPresented: $showReadAll) {
                Button(viewModel.resources.readAll, action: {
                    viewModel.markAllAsRead()
                })
            }
            .toolbar(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarItems()
            }
    }

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 8) {
                viewModel.resources.chatLogo
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.init(r: 14, g: 142, b: 243)))
                Text("0.50 \(viewModel.resources.AUR)")
                    .font(.subheadlineRegular15)
                    .foreground(.chineseBlack)
            }
        }
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
            HStack(spacing: 4) {
                Button {
                    viewModel.eventSubject.send(.onCreateChat)
                } label: {
                    viewModel.resources.squareAndPencil
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(r: 14, g:142, b: 243)))
                }
                Button(action: {
                    showReadAll.toggle()
                }, label: {
                    viewModel.resources.ellipsisCircle
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(14, 142, 243)))
                })
                .padding(.trailing, 0)
            }
        }
    }
}
