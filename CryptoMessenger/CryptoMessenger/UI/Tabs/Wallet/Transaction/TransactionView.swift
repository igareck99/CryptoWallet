import SwiftUI

// MARK: - TransactionView

struct TransactionView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: TransactionViewModel
    @State var showTransactionDetail = false
    @State var presentFilter = false
    @State var selectorFilterIndex = 0
    @State var selectorTokenIndex = 0
    @State var address = ""
	@State var tappedTransaction: TransactionInfo

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Divider()
            List {
                ForEach(filterTypeTransaction()) { item in
                    TransactionInfoView(transaction: item)
                        .listRowBackground(tappedTransaction == item && showTransactionDetail ?
                                           viewModel.resources.textColor : viewModel.resources.background)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            if showTransactionDetail {
                                if item == tappedTransaction {
                                    showTransactionDetail = false
                                } else {
                                    tappedTransaction = item
                                }
                            } else {
                                showTransactionDetail = true
                                tappedTransaction = item
                            }
                        }
                    if tappedTransaction == item && showTransactionDetail {
                        TransactionInfoDetailView(transaction: item)
                            .background(viewModel.resources.textColor)
                            .listRowBackground(viewModel.resources.textColor)
                }
            }
        }
            .listStyle(.plain)
        .onAppear {
            viewModel.send(.onAppear)
        }
    }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.resources.transactionTitleAll)
                    .font(.callout2Semibold16)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    R.image.transaction.filter.image
                        .onTapGesture {
                            presentFilter = true
                        }
                }
            }
        }
        .popup(isPresented: $presentFilter,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: viewModel.resources.backgroundFodding) {
            FilterTransactionView(viewModel: viewModel,
                                  selectorFilterIndex: $selectorFilterIndex,
                                  selectorTokenIndex: $selectorTokenIndex,
                                  presentFilter: $presentFilter)
                .frame(width: UIScreen.main.bounds.width,
                       height: 375, alignment: .center)
                .background(viewModel.resources.background)
                .cornerRadius(16)
        }
    }

    // MARK: - Private Methods

    private func filterTypeTransaction() -> [TransactionInfo] {
        var resultTransaction: [TransactionInfo] = []
        switch selectorFilterIndex {
        case 0:
            resultTransaction = viewModel.transactionList
        case 1:
            resultTransaction = viewModel.transactionList.filter { item in
                item.type == .send
            }
        case 2:
            resultTransaction = viewModel.transactionList.filter { item in
                item.type == .receive
            }
        default:
            break
        }
        switch selectorTokenIndex {
        case 0:
            resultTransaction = resultTransaction.filter { item in
                item.transactionCoin == .ethereum
            }
        case 1:
            resultTransaction = resultTransaction.filter { item in
                item.transactionCoin == .aura
            }
        default:
            return resultTransaction
        }
        if !address.isEmpty {
            return resultTransaction.filter { item in
                item.from == address
            }
        } else {
            return resultTransaction
        }
    }
}
