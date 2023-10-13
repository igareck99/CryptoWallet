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
                Divider()
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        ForEach(actions, id: \.id) { action in
                            Group {
                                action.view()
                                    .frame(idealHeight: 57)
                                Divider()
                                    .padding(.leading, 54)
                                    .frame(height: 0.5)
                            }
                        }
                        ForEach(views, id: \.id) { section in
                                section.view()
                        }
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
