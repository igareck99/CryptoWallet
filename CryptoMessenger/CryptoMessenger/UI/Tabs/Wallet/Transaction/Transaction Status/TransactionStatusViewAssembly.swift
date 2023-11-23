import SwiftUI

enum TransactionStatusViewAssemlby {
    static func build(model: TransactionStatus) -> some View {
        let viewModel = TransactionStatusViewModel(model: model)
        let view = TransactionStatusView(viewModel: viewModel)
        return view
    }
}
