import SwiftUI

// MARK: - ChooseReceiverNewView

struct ChooseReceiverNewView<ViewModel>: View where ViewModel: ChooseReceiverViewModelProtocol {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @State private var testView = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            searchSelectView
            List {
                ForEach(viewModel.userWalletsViews, id: \.id) { value in
                    value.view()
                }
            }
            .listStyle(.plain)
        }
        .searchable(text: $viewModel.searchText, prompt: "Поиск")
        .onSubmit(of: .search) {
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .toolbar {
            toolBarContent()
        }
    }
    
    // MARK: - Private Properties

    private var searchSelectView: some View {
        HStack(spacing: 0) {
            SearchTypeView(selectedSearchType: $viewModel.searchType,
                           searchTypeCell: SearchType.telephone )
            SearchTypeView(selectedSearchType: $viewModel.searchType,
                           searchTypeCell: SearchType.wallet )
        }
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.chooseReceiverTitle)
                .font(.system(size: 17, weight: .semibold))
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.onScanner($viewModel.scannedText)
            } label: {
                viewModel.resources.qrcode
            }
        }
    }
}
