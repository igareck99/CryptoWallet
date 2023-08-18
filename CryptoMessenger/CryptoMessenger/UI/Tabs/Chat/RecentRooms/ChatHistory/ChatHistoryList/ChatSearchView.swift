import SwiftUI

// MARK: - ChatSearchView

struct ChatSearchView<ViewModel>: View where ViewModel: ChatHistoryViewDelegate {
    
    @ObservedObject var viewModel: ViewModel
    @Environment(\.isSearching) private var isSearching
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading, .noData, .emptySearch:
                ChatHistoryEmptyState(viewModel: viewModel)
            case .chatsData, .chatsFinded:
                List {
                    ForEach(viewModel.chatSections, id: \.id) { section in
                        section.view()
                    }
                }
            }
        }
        .onChange(of: isSearching, perform: { value in
            viewModel.searchText.wrappedValue = ""
            viewModel.isSearching = value
        })
        .listStyle(.plain)
        
    }
}
