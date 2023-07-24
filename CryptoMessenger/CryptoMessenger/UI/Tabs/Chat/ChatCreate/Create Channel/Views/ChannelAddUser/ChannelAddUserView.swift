import SwiftUI

// MARK: - ChannelAddUserView

struct ChannelAddUserView: View {

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: SelectContactViewModel
    @State private var pickedContacts: [Contact] = []
    var onUsersSelected: ([Contact]) -> Void

    // MARK: - Internal Properties

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            Text(R.string.localizable.createChannelAdding())
                .font(.system(size: 17, weight: .regular))
                .padding(.leading, 16)
                .foregroundColor(.romanSilver)
            Divider()
            content
                .padding(.top, 11)
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            createToolBar()
        }
    }

    // MARK: - Private properties

    private var content: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            if viewModel.existingContacts.isEmpty {
                ProgressView()
                    .tint(Color.dodgerBlue)
            }
            List {
                let groupedContacts = Dictionary(grouping: viewModel.existingContacts) {
                    $0.name.firstLetter.uppercased()
                }
                ForEach(groupedContacts.keys.sorted(), id: \.self) { key in
                    sectionView(key)
                    let contacts = groupedContacts[key] ?? []
                    ForEach(0..<contacts.count) { index in
                        let contact = contacts[index]
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 21) {
                                if pickedContacts.contains(where: { $0.id == contact.id }) {
                                    R.image.chat.group.check.image
                                        .transition(.scale.animation(.linear(duration: 0.2)))
                                } else {
                                    R.image.chat.group.uncheck.image
                                                .transition(.opacity.animation(.linear(duration: 0.2)))
                                }
                                HStack(spacing: 10) {
                                    AsyncImage(
                                        defaultUrl: contact.avatar,
                                        placeholder: {
                                            ZStack {
                                                Color.aliceBlue
                                                Text(contact.name.firstLetter.uppercased())
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 22, weight: .medium))
                                            }
                                        },
                                        result: {
                                            Image(uiImage: $0).resizable()
                                        }
                                    )
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)

                                    Text(contact.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.chineseBlack)
                                        .padding(.top, 12)
                                }
                                Spacer()
                            }
                            .frame(height: 64)
                            .id(contact.id)
                            .onTapGesture {
                                vibrate()
                                if pickedContacts.contains(where: { $0.id == contact.id }) {
                                    pickedContacts.removeAll { $0.id == contact.id }
                                } else {
                                    pickedContacts.append(contact)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.top, 1)
    }

    private func sectionView(_ title: String) -> some View {
        EmptyView()
    }

    // MARK: - Private Methods

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                pickedContacts = []
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text(R.string.localizable.createChannelAllUsers())
                .font(.system(size: 17, weight: .bold))
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                onUsersSelected(pickedContacts)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.dodgerBlue)
            })
        }
    }
}
