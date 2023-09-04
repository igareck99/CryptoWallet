import SwiftUI

// MARK: - AdminsView

struct AdminsView<ViewModel>: View where ViewModel: AdminsViewModelDelegate {

    // MARK: - Private Properties

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                toolbarItems()
            }
    }

    private var content: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundColor(.gray)
            List {
                ForEach(viewModel.membersViews, id: \.id) { value in
                    value.view()
                }
            }
            .listStyle(.plain)
        }
    }

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }

        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.channelInfoAdmins)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(viewModel.resources.titleColor)
        }
    }
}
