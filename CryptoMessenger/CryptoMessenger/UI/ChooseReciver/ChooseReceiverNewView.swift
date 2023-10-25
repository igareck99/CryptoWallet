import SwiftUI

// MARK: - ChooseReceiverNewView

struct ChooseReceiverNewView<ViewModel>: View where ViewModel: ChooseReceiverViewModelProtocol {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @State private var testView = false
    
    // MARK: - Body
    
    var body: some View {
        legacyContent
            .hideKeyboardOnTap()
            .onAppear {
                viewModel.send(.onAppear)
            }
    }
    
    private var legacyContent: some View {
        VStack {
            SearchBar(placeholder: "Поиск", searchText: $viewModel.searchText, searching: $viewModel.isSearching)
                .padding(.horizontal, 16)
            searchSelectView
                .padding(.top, 12)
            List {
                ForEach(viewModel.userWalletsViews, id: \.id) { value in
                    value.view()
                }
            }
            .listStyle(.plain)
        }
        .toolbar {
            toolBarContent()
        }
    }
    
    private var content: some View {
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
                .font(.bodySemibold17)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.onScanner($viewModel.searchText)
            } label: {
                viewModel.resources.qrcode
            }
        }
    }
}
