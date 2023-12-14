import SwiftUI

// MARK: - ChatCreateView

struct ChatCreateView<ViewModel>: View where ViewModel: ChatCreateViewModelProtocol {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @State private var groupCreated = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                createToolBar()
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
            .popup(
                isPresented: viewModel.isSnackbarPresented,
                alignment: .bottom
            ) {
                Snackbar(
                    text: viewModel.snackBarText,
                    color: viewModel.shackBarColor
                )
            }
    }

    private var content: some View {
        ChatCreateContentView(
            actions: $viewModel.actions,
            views: $viewModel.lastUsersSections,
            viewState: $viewModel.state,
            isSearchingState: $viewModel.isSearching
        )
        .searchable(
            text: $viewModel.searchText,
            prompt: viewModel.resources.search
        )
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                viewModel.dismissCurrentCoodinator()
            }, label: {
                Text(viewModel.resources.cancel)
                    .font(.bodyRegular17)
                    .foregroundColor(.dodgerBlue)
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.tabChat)
                .font(.bodySemibold17)
        }
    }
}
