import SwiftUI

// MARK: - ChooseReceiverNewView

struct ChooseReceiverNewView<ViewModel>: View where ViewModel: ChooseReceiverViewModelProtocol {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    
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
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: viewModel.messageText,
                color: .spanishCrimson
            )
        }
        .searchable(text: $viewModel.searchText, prompt: "Поиск")
        .navigationBarBackButtonHidden(true)
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
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.chooseReceiverTitle)
                .font(.bodySemibold17)
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
