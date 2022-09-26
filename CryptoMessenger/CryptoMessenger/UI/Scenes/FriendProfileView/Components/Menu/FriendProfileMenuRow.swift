import SwiftUI

// MARK: - FriendProfileMenuRow

struct FriendProfileMenuRow: View {

    // MARK: - Internal Properties

    let item: FriendProfileSettingsMenu

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(item == .block || item == .complain ? Color(.red(0.1)) : Color(.blue(0.1)))
                    .frame(width: 40, height: 40)
                item.result.image
                    .frame(width: 20, height: 20)
            }
            Text(item.result.title)
                .font(.regular(15))
                .foregroundColor(item == .block || item == .complain ? Color(.red()) : Color(.blue()))
                .padding(.leading, 16)

            Spacer()
        }
    }
}
