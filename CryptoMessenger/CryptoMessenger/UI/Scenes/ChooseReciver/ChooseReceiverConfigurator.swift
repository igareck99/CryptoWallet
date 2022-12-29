import SwiftUI

// MARK: - ChooseReceiverConfigurator

enum ChooseReceiverConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ChooseReceiverSceneDelegate?,
                               receiverData: Binding<UserReceiverData>) -> ChooseReceiverView {
		let userSettings = UserDefaultsService.shared
        let viewModel = ChooseReceiverViewModel(userSettings: userSettings)
        viewModel.delegate = delegate
        let view = ChooseReceiverView(receiverData: receiverData,
                                      viewModel: viewModel)
        return view
    }
}
