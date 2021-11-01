import SwiftUI

// MARK: - ContactRow

struct ContactRow: View {

    // MARK: - Internal Properties

    let image: Image
    let name: String
    let status: String
    var hideSeparator = false
    var showInviteButton = false
    var onInvite: VoidBlock?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.semibold(15))
                        .foreground(.black())

                    if !status.isEmpty {
                        Text(status)
                            .font(.regular(13))
                            .foreground(.darkGray())
                    }
                }
                .frame(height: 64)

                Spacer()

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
            .padding([.leading, .trailing], 16)

            if !hideSeparator {
                Rectangle()
                    .fill(Color(.gray(0.7)))
                    .frame(height: 1)
                    .padding(.leading, 68)
                    .padding(.trailing, 16)
            }
        }
    }
}
