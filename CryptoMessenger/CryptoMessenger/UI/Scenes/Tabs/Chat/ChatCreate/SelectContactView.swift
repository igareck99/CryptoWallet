import SwiftUI

// MARK: - SelectContactView

struct SelectContactView: View {

    // MARK: - Internal Properties

    @Binding var contacts: [Contact]
    var onSelectContacts: GenericBlock<[Contact]>?

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var isActive = false
    @State private var selectedRows = Set<UUID>()

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        R.image.navigation.backButton.image
                    })
                }

                ToolbarItem(placement: .principal) {
                    Text("Групповой чат")
                        .font(.bold(15))
                        .foreground(.black())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isActive.toggle()
                        onSelectContacts?(contacts.filter({ selectedRows.contains($0.id) }))
                    }, label: {
                        Text("Готово")
                            .font(.semibold(15))
                            .foreground(selectedRows.isEmpty ? .darkGray() : .blue())
                    })
                        .disabled(selectedRows.isEmpty)
                        .background(
                            EmptyNavigationLink(destination: ChatGroupView(), isActive: $isActive)
                        )
                }
            }
    }

    private var content: some View {
        ZStack {
            Color(.white()).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                //sectionView("K")
                ForEach(contacts) { contact in
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            if selectedRows.contains(contact.id) {
                                R.image.chat.group.check.image
                                    .transition(.scale.animation(.linear(duration: 0.2)))
                            } else {
                                R.image.chat.group.uncheck.image
                                    .transition(.opacity.animation(.linear(duration: 0.2)))
                            }

                            ContactRow(
                                avatar: contact.avatar,
                                name: contact.name,
                                status: contact.status
                            )
                                .id(contact.id)
                                .onTapGesture {
                                    vibrate()
                                    if selectedRows.contains(contact.id) {
                                        selectedRows.remove(contact.id)
                                    } else {
                                        selectedRows.insert(contact.id)
                                    }
                                }
                        }
                        .padding(.leading, 16)
                    }
                }
            }
        }
    }

    private func sectionView(_ title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.medium(15))
                .foreground(.black())
                .padding(.leading, 16)
                .frame(height: 24)

            Spacer()
        }
        .background(.paleBlue())
    }
}
