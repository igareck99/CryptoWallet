import Combine
import SwiftUI

// swiftlint: disable all

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
    }
    
    // MARK: - Body Properties
    
    var content: some View {
        ChatSearchView(viewModel: viewModel)
            .searchable(text: viewModel.searchText)
            .confirmationDialog("", isPresented: $showReadAll) {
                Button(viewModel.sources.readAll, action: {
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
                viewModel.sources.chatLogo
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.init(r: 14, g:142, b: 243)))
                Text("0.50 \(viewModel.sources.AUR)")
                    .font(.regular(15))
                    .foreground(.black())
            }
        }
        
        ToolbarItem(placement: .principal) {
            HStack(spacing: 4) {
                Text(viewModel.sources.chats)
                    .multilineTextAlignment(.center)
                    .font(.bold(17))
                    .foreground(.black())
                    .accessibilityAddTraits(.isHeader)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 4) {
                Button {
                    viewModel.eventSubject.send(.onCreateChat($chatData))
                } label: {
                    viewModel.sources.squareAndPencil
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(r: 14, g:142, b: 243)))
                }
                Button(action: {
                    showReadAll.toggle()
                }, label: {
                    viewModel.sources.ellipsisCircle
                        .renderingMode(.original)
                        .foregroundColor(Color(.init(14, 142, 243)))
                })
                .padding(.trailing, 0)
            }
        }
    }
}
