import SwiftUI

// MARK: - ChatHistoryRow

struct ChatHistoryRow: View {

	let room: ChatHistoryData
    let isFromCurrentUser: Bool

	// MARK: - Body

	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
                AvatarViewData(avatarUrl: room.roomAvatar,
                               roomName: room.roomName, isDirect: room.isDirect,
                               isOnline: room.isOnline).view()
                .padding(.init(top: 2, leading: 14, bottom: 0, trailing: 0))
                VStack(alignment: .leading, spacing: 0) {
                    NameViewModel(lastMessageTime: room.lastMessageTime,
                                  roomName: room.roomName).view()
                    LastMessageData(messageType: room.lastMessage,
                                    isFromCurrentUser: isFromCurrentUser,
                                    unreadedEvents: room.unreadedEvents,
                                    isPinned: room.isPinned).view()
					Spacer()
				}.padding(.init(top: 10, leading: 10, bottom: 0, trailing: 0))
			}.frame(height: 76)
            Divider()
                .foregroundColor(Color(.init(216, 216, 217)))
                .frame(height: 0.5)
                .padding(.leading, 88)
		}.frame(height: 76)
            .onTapGesture {
                room.onTap(room)
            }
            .onLongPressGesture {
                room.onLongPress(room)
            }
	}
}
