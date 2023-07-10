import SwiftUI

// MARK: - MembersView

struct MembersView: View {

    // MARK: - Private Properties

    @StateObject var viewModel: MembersViewModel
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
                    Text("Участники чата")
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
                ForEach(0..<viewModel.chatData.contacts.count) { index in
                    let contact = viewModel.chatData.contacts[index]
                    VStack(spacing: 0) {
                        ContactRow(
                            avatar: contact.avatar,
                            name: contact.name,
                            status: contact.status,
                            hideSeparator: contact.id == viewModel.chatData.contacts.last?.id,
                            isAdmin: contact.isAdmin
                        )
                            .background(.white())
                    }
                    .onTapGesture {
                        viewModel.onProfile(contact)
                    }
                }
            }
        }
    }
}
