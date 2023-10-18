import SwiftUI

// MARK: - ChatSearchView

struct ChatSearchView: View {

    @Binding var views: [any ViewGeneratable]
    @Binding var viewState: ChatHistoryViewState
    @Binding var isSearchingState: Bool
    @Environment(\.isSearching) private var isSearching

    // MARK: - Body

    var body: some View {
        VStack {
            switch viewState {
            case .loading, .noData, .emptySearch, .noChats:
                ChatHistoryEmptyState(viewState: $viewState)
            case .chatsData, .chatsFinded:
                List {
                    ForEach(views, id: \.id) { section in
                            section.view()
                    }
                }
            }
        }
        .onChange(of: isSearching, perform: { value in
            isSearchingState = value
        })
        .listStyle(.plain)
    }
}
