import SwiftUI

// MARK: - SettingsAssembly

enum SettingsAssembly {

    // MARK: - Static Methods

    static func build(
        chatData: Binding<ChatData>,
        isLeaveRoom: Binding<Bool>,
        saveData: Binding<Bool>,
        room: AuraRoom,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) -> some View {
        let groupCallsUseCase = GroupCallsUseCase(room: room.room)
        let viewModel = SettingsViewModel(room: room)
        viewModel.coordinator = coordinator
        return SettingsView(isLeaveRoom: isLeaveRoom,
                            chatData: chatData,
                            saveData: saveData,
                            viewModel: viewModel)
    }
}
