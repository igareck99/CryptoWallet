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
    }

    private var content: some View {
        ChatCreateContentView(actions: $viewModel.actions,
                              views: $viewModel.lastUsersSections,
                              viewState: $viewModel.state,
                              isSearchingState: $viewModel.isSearching)
        .searchable(text: $viewModel.searchText)
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
               Text("Отмена")
                    .font(.regular(17))
                    .foregroundColor(.azureRadianceApprox)
            })
        }
        ToolbarItem(placement: .principal) {
            Text("Чаты")
                .font(.semibold(17))
        }
    }
}
