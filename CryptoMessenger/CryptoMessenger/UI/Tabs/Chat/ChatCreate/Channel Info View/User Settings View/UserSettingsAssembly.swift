import SwiftUI

enum UserSettingsAssembly {
    static func build(
        userId: Binding<String>,
        showBottomSheet: Binding<Bool>,
        showUserProfile: Binding<Bool>,
        roomId: String,
        roleCompare: ChannelUserActions,
        onActionEnd: @escaping VoidBlock,
        onUserProfile: @escaping VoidBlock
    ) -> some View {
        let viewModel = UserSettingsViewModel(
            userId: userId,
            showBottomSheet: showBottomSheet,
            showUserProfile: showUserProfile,
            roomId: roomId,
            roleCompare: roleCompare,
            onActionEnd: onActionEnd,
            onUserProfile: onUserProfile
        )
        let view = UserSettingsView(viewModel: viewModel)
        return view
    }
}
