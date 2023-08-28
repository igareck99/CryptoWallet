import SwiftUI

// MARK: - ChatCreateContentView

struct ChatCreateContentView: View {

    // MARK: - Internal Properties

    @Binding var actions: [any ViewGeneratable]
    @Binding var views: [any ViewGeneratable]
    @Binding var viewState: ChatCreateFlow.ViewState
    @Binding var isSearchingState: Bool
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        VStack {
            switch viewState {
            case .contactsAccessFailure:
                ChatCreateContactsErrorView()
            case .showContent:
                List {
                    ForEach(actions, id: \.id) { action in
                        action.view()
                    }
                    ForEach(views, id: \.id) { section in
                        section.view()
                    }
                }
            default:
                EmptyView()
            }
        }
        .onChange(of: isSearching, perform: { value in
            isSearchingState = value
        })
        .listStyle(.plain)
    }
}
