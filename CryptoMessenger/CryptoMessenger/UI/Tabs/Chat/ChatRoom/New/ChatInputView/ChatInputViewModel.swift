import SwiftUI

// MARK: - ChatInputViewModel

struct ChatInputViewModel: ViewGeneratable {
    var id = UUID()
    @Binding var isWriteEnable: Bool
    @Binding var inputText: String
    @Binding var activeEditMessage: RoomEvent?
    @Binding var quickAction: QuickActionCurrentUser?
    var sendText: () -> Void
    var onChatRoomMenu: () -> Void
    var sendAudio: (RecordingDataModel) -> Void
    
    func view() -> AnyView {
        ChatInputView(data: self).anyView()
    }
}
