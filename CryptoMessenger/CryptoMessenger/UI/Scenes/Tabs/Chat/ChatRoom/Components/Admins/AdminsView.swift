import SwiftUI

// MARK: - AdminsView

struct AdminsView: View {

    // MARK: - Private Properties

    @StateObject var viewModel: AdminsViewModel
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

            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<viewModel.chatData.admins.count) { index in
                    let contact = viewModel.chatData.admins[index]
                    VStack(spacing: 0) {
                        ContactRow(
                            avatar: contact.avatar,
                            name: contact.name,
                            status: contact.status,
                            hideSeparator: contact.id == viewModel.chatData.admins.last?.id
                        ).background(.white())
                    }
                    .onTapGesture {
                        viewModel.onProfile(contact)
                    }
                }
            }
        }
    }
}
