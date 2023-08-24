import SwiftUI

// MARK: - ChooseReceiverAssembly

enum ChooseReceiverAssembly {

    // MARK: - Static Methods

    static func build(
        receiverData: Binding<UserReceiverData>,
        coordinator: TransferViewCoordinatable
    ) -> some View {
        let viewModel = ChooseReceiverNewViewModel(receiverData: receiverData, coordinator: coordinator)
        let view = ChooseReceiverNewView(viewModel: viewModel)
        return view
    }
}
