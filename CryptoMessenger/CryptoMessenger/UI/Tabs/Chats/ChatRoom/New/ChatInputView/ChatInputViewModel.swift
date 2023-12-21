import SwiftUI

// MARK: - ChatInputViewModel

struct ChatInputViewModel: ViewGeneratable {
    var id = UUID()
    @Binding var isWriteEnable: Bool
    @Binding var inputText: String
    @Binding var activeEditMessage: RoomEvent?
    @Binding var quickAction: QuickActionCurrentUser?
    @Binding var replyDescriptionText: String
    var sendText: () -> Void
    var onChatRoomMenu: () -> Void
    var sendAudio: (RecordingDataModel) -> Void
    
    init(id: UUID = UUID(), isWriteEnable:Binding<Bool>,
         inputText: Binding<String>,
         activeEditMessage: Binding<RoomEvent?>,
         quickAction: Binding<QuickActionCurrentUser?>,
         replyDescriptionText: Binding<String>,
         sendText: @escaping () -> Void,
         onChatRoomMenu: @escaping () -> Void,
         sendAudio: @escaping (RecordingDataModel) -> Void) {
        self.id = id
        self._isWriteEnable = isWriteEnable
        self._inputText = inputText
        self._activeEditMessage = activeEditMessage
        self._quickAction = quickAction
        self._replyDescriptionText = replyDescriptionText
        self.sendText = sendText
        self.onChatRoomMenu = onChatRoomMenu
        self.sendAudio = sendAudio
    }
    
    func view() -> AnyView {
        ChatInputView(data: self).anyView()
    }
}
