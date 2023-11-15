import SwiftUI

// MARK: - FilterTransactionView

struct FilterTransactionView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: TransactionViewModel
    @Binding var selectorFilterIndex: Int
    @Binding var selectorTokenIndex: Int
    @Binding var presentFilter: Bool
    @State private var transactionFilters = [
        TransactionFilterType.allTransaction.result,
        TransactionFilterType.sendOnly.result,
        TransactionFilterType.receiveOnly.result
    ]

    @State private var tokenFilters = [
        WalletType.ethereum.currency,
        WalletType.aura.currency
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foregroundColor(.romanSilver07)
                .padding(.top, 6)

            HStack {
                Text(R.string.localizable.transactionFilter().uppercased(), [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left))
                ])
                .font(.caption1Medium12)
                .foregroundColor(.romanSilver)
                Spacer()
            }
            .padding(.top, 8)
            .padding([.leading, .trailing], 16)
            HStack {
                RadioGroupPicker(selectedIndex: $selectorFilterIndex, titles: transactionFilters)
                    .titleFont(.boldSystemFont(ofSize: 15))
                    .buttonSize(18)
                    .itemSpacing(12)
                    .spacing(20)
                    .fixedSize()
                    .padding(.top, 12)
                Spacer()
            }
            .padding(.leading, 16)
            HStack {
                Text(R.string.localizable.transactionTokenFilter(), [
                    .paragraph(.init(lineHeightMultiple: 1.22, alignment: .left))
                ])
                .font(.caption1Medium12)
                .foregroundColor(.romanSilver)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.top, 24)
            HStack {
                RadioGroupPicker(selectedIndex: $selectorTokenIndex, titles: tokenFilters)
                    .titleFont(.boldSystemFont(ofSize: 15))
                    .buttonSize(18)
                    .itemSpacing(12)
                    .spacing(20)
                    .fixedSize()
                    .padding(.top, 12)
                Spacer()
            }
            .padding(.top, 12)
            .padding(.leading, 16)
            Spacer()
        }
    }
}

// MARK: - TransactionFilterType

enum TransactionFilterType {

    // MARK: - Internal Properties

    case allTransaction
    case sendOnly
    case receiveOnly

    // MARK: - Internal Properties

    var result: String {
        switch self {
        case .allTransaction:
            return R.string.localizable.walletAllTransaction()
        case .sendOnly:
            return R.string.localizable.transactionOnlySent()
        case .receiveOnly:
            return R.string.localizable.transactionOnlyReceived()
        }
    }
}
