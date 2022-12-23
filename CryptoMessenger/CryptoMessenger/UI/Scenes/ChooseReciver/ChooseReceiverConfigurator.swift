import SwiftUI

// MARK: - ChooseReceiverConfigurator

enum ChooseReceiverConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChooseReceiverSceneDelegate?,
                               address: Binding<String>) -> ChooseReceiverView {
		let userSettings = UserDefaultsService.shared
        let viewModel = ChooseReceiverViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = ChooseReceiverView(address: address,
                                      viewModel: viewModel)
        return view
    }
}
