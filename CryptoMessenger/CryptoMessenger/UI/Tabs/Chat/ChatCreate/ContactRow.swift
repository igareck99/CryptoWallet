import SwiftUI

// MARK: - ContactRow

struct ContactRow: View {

    // MARK: - Internal Properties

    let contact: Contact
    var showInviteButton = false
    var isAdmin = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                AsyncImage(
                    defaultUrl: contact.avatar,
                    placeholder: {
                        ZStack {
                            Color(.lightBlue())
                            Text(contact.name.firstLetter.uppercased())
                                .foreground(.white())
                                .font(.medium(22))
                        }
                    },
                    result: {
                        Image(uiImage: $0).resizable()
                    }
                )
                .scaledToFill()
                .frame(width: 40, height: 40)
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(contact.name)
                            .lineLimit(1)
                            .font(.semibold(15))
                            .foreground(.black())

                        Spacer()

                        if contact.isAdmin {
                            Text("Админ", [
                                .color(.darkGray()),
                                .font(.regular(13)),
                                .paragraph(.init(lineHeightMultiple: 1, alignment: .right))
                            ])
                        }
                    }

                    if !contact.status.isEmpty {
                        Text(contact.status)
                            .lineLimit(1)
                            .font(.regular(13))
                            .foreground(.darkGray())
                    }
                }
                .frame(height: 64)

                if !isAdmin {
                    Spacer()
                }

                if contact.type == .waitingContacts {
                    Button {
                        contact.onTap(contact)
                    } label: {
                        Text("Пригласить")
                            .font(.regular(15))
                            .foreground(.blue())
                            .frame(width: 115, height: 32, alignment: .center)
                    }
                    .frame(width: 115, height: 32, alignment: .center)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(.blue()), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 16)
            .onTapGesture {
                switch contact.type {
                case .waitingContacts:
                    break
                default:
                    contact.onTap(contact)
                }
            }
        }
    }
}
