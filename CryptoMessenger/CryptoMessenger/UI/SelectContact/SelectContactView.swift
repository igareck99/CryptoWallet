import Combine
import Foundation
import SwiftUI

// MARK: - SelectContactView

struct SelectContactView<ViewModel>: View where ViewModel: SelectContactViewModelDelegate {

    // MARK: - Private Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        content
            .toolbar(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                createToolBar()
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        List {
            ForEach(viewModel.usersViews, id: \.id) { value in
                value.view()
            }
        }
        .listStyle(.plain)
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
}
