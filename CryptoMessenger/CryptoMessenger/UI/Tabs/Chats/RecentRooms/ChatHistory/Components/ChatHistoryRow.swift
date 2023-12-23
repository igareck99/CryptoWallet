import SwiftUI

// MARK: - ChatHistoryRow

struct ChatHistoryRow: View {

    let room: ChatHistoryData
    let isFromCurrentUser: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                room.avatarView.view()
                    .padding(.init(top: 2, leading: 14, bottom: 0, trailing: 0))
                VStack(alignment: .leading, spacing: 0) {
                    room.nameView.view()
                    room.messageView.view()
                    Spacer()
                }.padding(.init(top: 10, leading: 10, bottom: 0, trailing: 0))
            }
            Divider()
                .foregroundColor(.brightGray)
                .frame(height: 0.5)
                .padding(.leading, 88)
        }
        .frame(height: 76)
        .frame(maxWidth: .infinity)
        .background()
        .onTapGesture {
            room.onTap(room)
        }
        .onLongPressGesture {
            room.onLongPress(room)
        }
    }
}
