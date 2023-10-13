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
                    .fill(item == .block || item == .complain ? Color.spanishCrimson01 : Color.dodgerTransBlue)
                    .frame(width: 40, height: 40)
                item.result.image
                    .frame(width: 20, height: 20)
            }
            Text(item.result.title)
                .font(.subheadlineRegular15)
                .foregroundColor(item == .block || item == .complain ? Color.spanishCrimson : Color.dodgerBlue)
                .padding(.leading, 16)

            Spacer()
        }
    }
}
