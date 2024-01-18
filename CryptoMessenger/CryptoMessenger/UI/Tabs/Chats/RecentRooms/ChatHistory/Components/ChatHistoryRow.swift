import SwiftUI

// MARK: - ChatHistoryRow

struct ChatHistoryRow: View {

    let room: ChatHistoryData
    let isFromCurrentUser: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            if room.isPinned {
                Divider()
                    .foregroundColor(.brightGray)
                    .frame(height: 0.5)
                    .padding(.top, 1)
            }
            HStack(alignment: .top, spacing: 0) {
                room.avatarView.view()
                room.messageView.view()
                    .padding(.leading, 10)
                Spacer()
                room.nameView.view()
            }
            .padding(.top, 3)
            .frame(width: UIScreen.main.bounds.width - 32,
                   height: 60, alignment: .center)
            .padding(.top, 7)
            .padding(.bottom, 9)
            Divider()
                .foregroundColor(.brightGray)
                .frame(height: 0.5)
                .padding(.leading, 88)
                .padding(.bottom, 1)
        }
        .frame(height: 76.5)
        .frame(maxWidth: .infinity)
        .background(content: {
            room.isPinned ? Color.ghostWhite : Color.white
        })
        .onTapGesture {
            room.onTap(room)
        }
        .onLongPressGesture {
            room.onLongPress(room)
        }
    }
}
