import SwiftUI

struct TransactionStatusView<ViewModel: TransactionStatusViewModelProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            List(viewModel.displayItems, id: \.hashValue) {
                $0.view()
            }
        }
        .safeAreaInset(edge: .bottom) {
            sendCodeButton
                .padding(.bottom)
        }
        .presentationDetents([.height(viewModel.height)])
    }

    private var sendCodeButton: some View {
        Button {
            viewModel.didTapOpenWalletButton()
        } label: {
            Text("Перейти в кошелек")
                .font(.bodySemibold17)
                .foregroundColor(.white)
        }
        .frame(width: 237, height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.dodgerBlue)
        )
    }
}
