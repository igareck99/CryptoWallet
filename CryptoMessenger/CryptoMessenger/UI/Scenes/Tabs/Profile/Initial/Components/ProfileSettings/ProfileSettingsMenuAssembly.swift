import SwiftUI

// MARK: - ProfileSettingsMenuAssembly

enum ProfileSettingsMenuAssembly {

    // MARK: - Static Methods

    static func build(balance: String,
                      onSelect: @escaping GenericBlock<ProfileSettingsMenu>) -> some View {
        let viewModel = ProfileSettingsMenuViewModel()
        let view = ProfileSettingsMenuView(viewModel: viewModel,
                                           balance: balance,
                                           onSelect: onSelect)
        return view
    }
}
