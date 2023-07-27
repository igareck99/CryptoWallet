import SwiftUI

// MARK: - MembersView

struct MembersView<ViewModel>: View where ViewModel: MembersViewModelDelegate {

    // MARK: - Private Properties

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                createToolBar()
            }
    }

    private var content: some View {
        VStack(spacing: 0) {
            Divider()
                .foreground(.gainsboro)
            List {
                ForEach(viewModel.membersViews, id: \.id) { value in
                    value.view()
                }
            }
            .listStyle(.plain)
        }
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
            Text("Участники чата")
                .font(.bold(15))
                .foreground(.black)
        }
    }
}
