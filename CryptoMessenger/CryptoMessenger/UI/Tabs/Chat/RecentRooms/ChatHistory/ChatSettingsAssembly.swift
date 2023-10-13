import SwiftUI

// MARK: - ChatSettingsAssembly

enum ChatSettingsAssembly {
    
    // MARK: - Static Methods
    
    static func build(_ room: AuraRoomData,
                      _ coordinator: ChatHistoryFlowCoordinatorProtocol) -> some View {
        let viewModel = ChatSettingsViewModel(room: room, coordinator: coordinator)
        let view = ChatSettingsView(viewModel: viewModel)
        return view
    }
}
