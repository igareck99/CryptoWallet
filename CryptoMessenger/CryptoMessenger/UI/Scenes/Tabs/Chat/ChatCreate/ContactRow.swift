import SwiftUI

// MARK: - ContactRow

struct ContactRow: View {

    // MARK: - Internal Properties

    let avatar: URL?
    let name: String
    let status: String
    var hideSeparator = false
    var showInviteButton = false
    var isAdmin = false
    var onInvite: VoidBlock?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                AsyncImage(
                    url: avatar,
                    placeholder: {
                        ZStack {
                            Color(.lightBlue())
                            Text(name.firstLetter.uppercased())
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
                    HStack(spacing: 0) {
                        Text(name)
                            .font(.semibold(15))
                            .foreground(.black())
                            .padding(.top, 12)

                        Spacer()

                        if isAdmin {
                            Text("Админ", [
                                .color(.darkGray()),
                                .font(.regular(13)),
                                .paragraph(.init(lineHeightMultiple: 1, alignment: .right))
                            ])
                                .padding(.top, 15)
                        }
                    }

                    if !status.isEmpty {
                        Text(status)
                            .font(.regular(13))
                            .foreground(.darkGray())
                            .padding(.bottom, 12)
                    }
                }
                .frame(height: 64)

                if !isAdmin {
                    Spacer()
                }

                if showInviteButton {
                    Button {
                        onInvite?()
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

            if !hideSeparator {
                Rectangle()
                    .fill(Color(.gray(0.7)))
                    .frame(height: 1)
                    .padding(.leading, 68)
            }
        }
    }
}
