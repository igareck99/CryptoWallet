import SwiftUI

// MARK: - SettingsConfigurator

enum SettingsConfigurator {

    // MARK: - Static Methods

    static func configuredView(
        delegate: SettingsSceneDelegate?,
        chatData: Binding<ChatData>,
        isLeaveRoom: Binding<Bool>,
        saveData: Binding<Bool>,
        room: AuraRoom
    ) -> SettingsView {
        let groupCallsUseCase = GroupCallsUseCase(room: room.room)
        let viewModel = SettingsViewModel(room: room)
        viewModel.delegate = delegate
        return SettingsView(isLeaveRoom: isLeaveRoom,
                            chatData: chatData,
                            saveData: saveData,
                            viewModel: viewModel)
    }
}
