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
                    defaultUrl: avatar,
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
                    HStack(alignment: .center, spacing: 0) {
                        Text(name)
                            .lineLimit(1)
                            .font(.semibold(15))
                            .foreground(.black())

                        Spacer()

                        if isAdmin {
                            Text("Админ", [
                                .color(.darkGray()),
                                .font(.regular(13)),
                                .paragraph(.init(lineHeightMultiple: 1, alignment: .right))
                            ])
                        }
                    }

                    if !status.isEmpty {
                        Text(status)
                            .lineLimit(1)
                            .font(.regular(13))
                            .foreground(.darkGray())
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
                    .frame(height: 0.5)
                    .padding(.leading, 68)
            }
        }
    }
}
