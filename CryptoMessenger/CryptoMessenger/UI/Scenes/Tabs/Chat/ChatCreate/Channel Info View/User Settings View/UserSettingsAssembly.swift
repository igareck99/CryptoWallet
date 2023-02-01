import SwiftUI

enum UserSettingsAssembly {
    static func build(
        userId: Binding<String>,
        showBottomSheet: Binding<Bool>,
        showUserProfile: Binding<Bool>,
        roomId: String,
        onActionEnd: @escaping VoidBlock
    ) -> some View {
        let viewModel = UserSettingsViewModel(
            userId: userId,
            showBottomSheet: showBottomSheet,
            showUserProfile: showUserProfile,
            roomId: roomId,
            onActionEnd: onActionEnd
        )
        let view = UserSettingsView(viewModel: viewModel)
        return view
    }
}
