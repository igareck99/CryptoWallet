import SwiftUI

enum ChooseReceiverAssembly {
    static func build(
        receiverData: Binding<UserReceiverData>,
        coordinator: TransferViewCoordinatable
    ) -> some View {
        let viewModel = ChooseReceiverNewViewModel(receiverData: receiverData, coordinator: coordinator)
        let view = ChooseReceiverNewView(viewModel: viewModel)
        return view
    }
}
