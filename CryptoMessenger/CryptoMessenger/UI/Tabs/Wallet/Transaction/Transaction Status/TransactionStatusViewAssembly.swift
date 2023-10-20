import SwiftUI

enum TransactionStatusViewAssemlby {
    static func build() -> some View {
        let viewModel = TransactionStatusViewModel()
        let view = TransactionStatusView(viewModel: viewModel)
        return view
    }
}
