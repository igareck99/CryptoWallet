import SwiftUI

enum ChatSettingsAssembly {
    static func build(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol
    ) -> some View {
        let viewModel = ChatSettingsViewModel(room: room, coordinator: coordinator)
        let view = ChatSettingsView(viewModel: viewModel)
        return view
    }
}
