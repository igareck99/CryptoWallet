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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        R.image.navigation.backButton.image
                    })
                }

                ToolbarItem(placement: .principal) {
                    Text("Администраторы")
                        .font(.bold(15))
                        .foreground(.black())
                }
            }
    }

    private var content: some View {
        VStack(spacing: 0) {
            Divider()
                .foreground(.grayE6EAED())
            List {
                ForEach(viewModel.membersViews, id: \.id) { value in
                    value.view()
                }
            }
            .listStyle(.plain)
        }
    }
}
