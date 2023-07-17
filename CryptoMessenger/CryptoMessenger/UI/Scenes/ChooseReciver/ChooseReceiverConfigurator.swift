import SwiftUI

// MARK: - ChooseReceiverConfigurator

enum ChooseReceiverConfigurator {

    // MARK: - Static Methods

    static func build(
        receiverData: Binding<UserReceiverData>,
        coordinator: WalletCoordinatable
    ) -> some View {
        let viewModel = ChooseReceiverViewModel(coordinator: coordinator)
        let view = ChooseReceiverView(receiverData: receiverData,
                                      viewModel: viewModel)
        return view
    }
}
