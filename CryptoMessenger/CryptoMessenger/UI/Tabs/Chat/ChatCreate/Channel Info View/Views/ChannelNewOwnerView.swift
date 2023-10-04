import SwiftUI

// MARK: - ChannelNewOwnerView

struct ChannelNewOwnerView: View {

    // MARK: - Internal Properties

    @Environment(\.presentationMode) private var presentationMode
    var users: [ChannelParticipantsData]
    @State private var pickedContacts: [ChannelParticipantsData] = []
    var onUsersSelected: ([ChannelParticipantsData]) -> Void

    // MARK: - Body

    var body: some View {
        VStack {
            content
                .padding(.top, 11)
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            createToolBar()
        }
    }

    private var content: some View {
        List {
            ForEach(users, id: \.self) { contact in
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 21) {
                        if pickedContacts.contains(where: { $0.matrixId == contact.matrixId }) {
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
                                            .font(.title2Regular22)
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
                                .font(.subheadlineRegular15)
                                .foregroundColor(.chineseBlack)
                                .padding(.top, 12)
                        }
                        Spacer()
                    }
                    .frame(height: 64)
                    .onTapGesture {
                        vibrate()
                        if pickedContacts.contains(where: { $0.matrixId == contact.matrixId }) {
                            pickedContacts.removeAll { $0.matrixId == contact.matrixId }
                        } else {
                            pickedContacts.append(contact)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
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
            Text(R.string.localizable.channelSettingsSelectOwner())
                .font(.bodyRegular17)
                .lineLimit(1)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                onUsersSelected(pickedContacts)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(R.string.localizable.profileDetailRightButton())
                    .font(.bodyRegular17)
                    .foregroundColor(.dodgerBlue)
            })
        }
    }
}
