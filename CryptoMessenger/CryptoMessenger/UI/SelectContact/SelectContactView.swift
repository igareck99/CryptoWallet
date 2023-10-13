import SwiftUI

// MARK: - SelectContactView

struct SelectContactView<ViewModel>: View where ViewModel: SelectContactViewModelDelegate {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    
    // MARK: - Private Properties
    
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        Group {
            switch viewModel.mode {
            case .send:
                NavigationView {
                    List {
                        ForEach(viewModel.usersViews, id: \.id) { value in
                            value.view()
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.visible, for: .navigationBar)
                    .toolbar {
                        createToolBarSend()
                    }
                    .searchable(text: $viewModel.searchText)
                    .listStyle(.plain)
                }
            case .groupCreate:
                VStack {
                    ContactsForSendView(views: $viewModel.usersForCreate,
                                        text: $viewModel.text)
                    List {
                        ForEach(viewModel.usersViews, id: \.id) { value in
                            value.view()
                        }
                    }
                    .hideKeyboardOnTap()
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.visible, for: .navigationBar)
                    .toolbar {
                        createToolBar()
                    }

                }
                .navigationBarBackButtonHidden(true)
            default:
                List {
                    ForEach(viewModel.usersViews, id: \.id) { value in
                        value.view()
                    }
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.visible, for: .navigationBar)
                .toolbar {
                    createToolBar()
                }
            }
        }
            .onAppear {
                viewModel.send(.onAppear)
            }
            .navigationBarBackButtonHidden(true)
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.contactsLimit == nil ? "Групповой чат" : "Выберите контакт")
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.onFinish()
            }, label: {
                Text("Готово")
                    .font(.bodyRegular17)
                    .foregroundColor(viewModel.getButtonColor())
            })
            .disabled(viewModel.isButtonAvailable)
        }
    }
    
    @ToolbarContentBuilder
    private func createToolBarSend() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.contactsLimit == nil ? viewModel.resources.createActionGroupChat : viewModel.resources.transferChooseContact)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                viewModel.dismissSheet()
            }, label: {
                Text(viewModel.resources.profileDetailRightButton)
                    .font(.bodyRegular17)
                    .foregroundColor(viewModel.resources.buttonBackground)
            })
        }
    }
}
