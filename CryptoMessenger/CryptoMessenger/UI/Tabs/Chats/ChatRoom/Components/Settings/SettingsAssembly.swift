import SwiftUI

enum SettingsAssembly {
    static func build(
        chatData: Binding<ChatData>,
        isLeaveRoom: Binding<Bool>,
        saveData: Binding<Bool>,
        room: AuraRoomData,
        coordinator: ChatsCoordinatable
    ) -> some View {
        let viewModel = SettingsViewModel(room: room)
        viewModel.coordinator = coordinator
        return SettingsView(
            isLeaveRoom: isLeaveRoom,
            chatData: chatData,
            saveData: saveData,
            viewModel: viewModel
        )
    }
}
