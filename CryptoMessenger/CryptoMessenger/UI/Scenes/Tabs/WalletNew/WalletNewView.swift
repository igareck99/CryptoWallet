import SwiftUI

// MARK: - WalletNewView

struct WalletNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletNewViewModel
    @State var contentWidth = CGFloat(0)
    @State var offset = CGFloat(16)
    @State var index = 0
    @State var showAddWallet = false

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                balanceView
                    .padding(.leading, 16)

                SlideCardsView(cards: viewModel.cardsList, onOffsetChanged: { off in
                    print(off)
                    let cardWidth = CGFloat(343)
                    let cardsCount = viewModel.cardsList.count
                    let delta = cardsCount > 1 ? (cardsCount - 1) * 8 : 0
                    let contentWidth = cardsCount > 1
                    ? CGFloat((cardsCount - 1) * Int(cardWidth) + delta)
                    : cardWidth

                    let percent = off / contentWidth

                    withAnimation(.linear(duration: 0.2)) {
                        if percent <= 0 {
                            offset = 16
                        } else if percent >= 0.65 {
                            offset = cardWidth - 111 + 32
                        } else {
                            offset = cardWidth * percent
                        }
                    }
                }, onAddressSend: { index, address in
                    viewModel.send(
                        .onTransactionAddress(selectorTokenIndex: index, address: address)
                    )
                }).padding(.top, 16)
            }

            VStack(spacing: 24) {
                cardsProgressView

                sendButton
                    .frame(height: 58)
                    .padding(.horizontal, 16)
                transactionTitleView
                    .padding(.top, 26)

                VStack(spacing: 0) {
                    ForEach(viewModel.transactionList) { item in
                        TransactionInfoView(transaction: item)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    }
                }
            }
            .padding(.top, 24)
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .popup(isPresented: $showAddWallet,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: Color(.black(0.3)),
               dismissCallback: { showTabBar() },
               view: {
            AddWalletView(viewModel: viewModel,
                          showAddWallet: $showAddWallet)
                .frame(width: UIScreen.main.bounds.width,
                       height: 114, alignment: .center)
                .background(.white())
                .cornerRadius(16)
        }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(R.string.localizable.tabWallet())
                    .font(.bold(15))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {

                } label: {
                    R.image.wallet.settings.image
                        .onTapGesture {
                            hideTabBar()
                            showAddWallet = true
                        }
                }
            }
        }

    }

    // MARK: - Private Properties

    private var cardsProgressView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foreground(.grayE6EAED())

            Rectangle()
                .frame(width: 111, height: 4)
                .foreground(.blue())
                .cornerRadius(2)
                .padding(.leading, offset)
        }
    }

    private var balanceView: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foreground(.lightBlue(0.1))
                R.image.wallet.wallet.image
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.totalBalance)
                    .font(.regular(22))
                Text(R.string.localizable.tabOverallBalance())
                    .font(.regular(13))
                    .foreground(.darkGray())
            }
        }
    }

    private var transactionTitleView: some View {
        HStack {
            Text(R.string.localizable.walletTransaction())
                .font(.medium(15))
                .padding(.leading, 16)
            Spacer()
            Button {
                viewModel.send(.onTransactionToken(selectorTokenIndex: -1))
            } label: {
                Text(R.string.localizable.walletAllTransaction())
                    .font(.regular(15))
                    .foreground(.blue())
                    .padding(.trailing, 16)
            }
        }
    }

    private var sendButton: some View {
        Button {
            viewModel.send(.onTransfer)
        } label: {
            Text(R.string.localizable.walletSend().uppercased())
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.semibold(14))
                .padding()
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .background(Color(.blue()))
        .cornerRadius(4)
    }
}

// MARK: - TransactionInfoView

struct TransactionInfoView: View {

    // MARK: - Internal Properties

    var transaction: TransactionInfo

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foreground(transaction.type == .send ? .blue() : .green())
                        transaction.type == .send ? R.image.wallet.writeOff.image :
                        R.image.wallet.inflow.image
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(transaction.type == .send ? R.string.localizable.walletShipped():
                                R.string.localizable.walletReceived())
                            .font(.medium(15))
                        Text(transaction.date + " " + "From:" + transaction.from)
                            .font(.regular(13))
                            .foreground(.darkGray())
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    switch transaction.transactionCoin {
                    case .aur:
                        Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " AUR":
                                String("- \(abs(transaction.amount))") + " AUR")
                            .font(.regular(15))
                            .foreground(transaction.type == .send ? .black(): .green())
                    case .ethereum:
                        Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " ETH":
                                String("- \(abs(transaction.amount))") + " ETH")
                            .font(.regular(15))
                            .foreground(transaction.type == .send ? .black(): .green())
                    case .bitcoin:
                        Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " BTC":
                                String("- \(abs(transaction.amount))") + " BTC")
                            .font(.regular(15))
                            .foreground(transaction.type == .send ? .black(): .green())
                    }
                    Text(String(transaction.amount) + " USD")
                        .font(.regular(13))
                        .foreground(.darkGray())
                }
            }
            Divider()
        }
    }
}
