import SwiftUI

// MARK: - ChatActionsView

struct ChatActionsView: View {

    // MARK: - Internal Properties

    let room: ChatActionsList
    let onSelect: GenericBlock<ChatActions>
    let viewHeight: GenericBlock<CGFloat>

    // MARK: - Body
    
    private var content: some View {
        ForEach(ChatActions.getAvailableActions(room.isWatchProfileAvailable,
                                                room.isLeaveAvailable), id: \.self) { value in
            ProfileSettingsMenuRow(title: value.text(room.isPinned), image: value.image,
                                   notifications: 0, color: value.color)
                .background(.white)
                .frame(height: 57)
                .onTapGesture {
                    onSelect(value)
                }
                .listRowSeparator(.hidden)
                .padding(.horizontal, 16)
        }
    }
    
    var body: some View {
        content
            .onAppear {
                let value = CGFloat(223 - (3 - ChatActions.getAvailableActions(room.isWatchProfileAvailable,
                                                                          room.isLeaveAvailable).count) * 57)
                viewHeight(value)
            }
    }
}
