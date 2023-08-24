import SwiftUI

// MARK: - SelectContactView

struct SelectContactView<ViewModel>: View where ViewModel: SelectContactViewModelDelegate {

    // MARK: - Private Properties

    @StateObject var viewModel: ViewModel

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
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
            ToolbarItem(placement: .principal) {
                Text(viewModel.contactsLimit == nil ? "Групповой чат" : "Выберите контакт")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(viewModel.resources.titleColor)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.onFinish()
                }, label: {
                    Text("Готово")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(viewModel.getButtonColor())
                })
                .disabled(viewModel.isButtonAvailable)
            }
    }
    
    @ToolbarContentBuilder
    private func createToolBarSend() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Контакты")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(viewModel.resources.titleColor)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                viewModel.dismissSheet()
            }, label: {
                Text("Отмена")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(viewModel.resources.buttonBackground)
            })
        }
    }
}
