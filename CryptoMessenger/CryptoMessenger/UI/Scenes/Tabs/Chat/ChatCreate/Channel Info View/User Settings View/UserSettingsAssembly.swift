import SwiftUI

// MARK: - UserSettingsAssembly

enum UserSettingsAssembly {

    // MARK: - Static Methods

    static func build(
        userId: Binding<String>,
        showBottomSheet: Binding<Bool>,
        showUserProfile: Binding<Bool>,
        roomId: String,
        roleCompare: Bool,
        onActionEnd: @escaping VoidBlock
    ) -> some View {
        let viewModel = UserSettingsViewModel(
            userId: userId,
            showBottomSheet: showBottomSheet,
            showUserProfile: showUserProfile,
            roomId: roomId,
            roleCompare: roleCompare,
            onActionEnd: onActionEnd
        )
        let view = UserSettingsView(viewModel: viewModel)
        return view
    }
}
