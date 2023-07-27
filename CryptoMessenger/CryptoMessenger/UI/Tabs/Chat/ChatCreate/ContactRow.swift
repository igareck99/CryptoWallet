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
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(contact.name)
                            .lineLimit(1)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.chineseBlack)
                        
                        Spacer()
                        
                        if contact.isAdmin {
                            Text(R.string.localizable.chatCreateAdmin(), [
                                .paragraph(.init(lineHeightMultiple: 1, alignment: .right))
                            ]).foregroundColor(.romanSilver)
                                .font(.system(size: 13, weight: .regular))
                        }
                    }
                    
                    switch contact.type {
                    case .sendContact:
                        Text(contact.phone)
                            .font(.regular(13))
                            .foregroundColor(.gray)
                    default:
                        Text(contact.status)
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.romanSilver)
                    }
                }
                
                if !isAdmin {
                    Spacer()
                }
                
                if contact.type == .waitingContacts {
                    Button {
                        contact.onTap(contact)
                    } label: {
                        Text(R.string.localizable.chatCreateInvite())
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.dodgerBlue)
                            .frame(width: 115, height: 32, alignment: .center)
                    }
                    .frame(width: 115, height: 32, alignment: .center)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.dodgerBlue, lineWidth: 1)
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
        .listRowSeparator(contact.type == .sendContact ? .hidden : .visible)
    }
}
