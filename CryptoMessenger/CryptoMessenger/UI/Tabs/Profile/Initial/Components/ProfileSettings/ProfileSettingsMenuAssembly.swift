import SwiftUI

// MARK: - ProfileSettingsMenuAssembly

enum ProfileSettingsMenuAssembly {

    // MARK: - Static Methods

    static func build(onSelect: @escaping GenericBlock<ProfileSettingsMenu>) -> some View {
        let viewModel = ProfileSettingsMenuViewModel(onSelect: onSelect)
        let view = ProfileSettingsMenuView(viewModel: viewModel)
        return view
    }
}
