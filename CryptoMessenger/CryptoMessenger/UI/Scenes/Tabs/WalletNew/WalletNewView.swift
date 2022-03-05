import SwiftUI

// MARK: - WalletNewView

struct WalletNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: WalletNewViewModel
    @State var offset: CGFloat = 0
    @State var index = 0

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16) {
                    balanceView
                        .padding(.leading, 16)
                    SlideCardsView(offset: $offset,
                                   index: $index,
                                   viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
                Spacer()
                VStack(spacing: 24) {
                    cardsProgressView
                        .frame(width: geometry.size.width - 32)
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
                .padding(.top, 190)
            }
        }
            .onAppear {
                viewModel.send(.onAppear)
            }
        .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(R.string.localizable.tabWallet())
                            .font(.bold(15))
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        R.image.wallet.settings.image
                    }
                }
                }

    }

    // MARK: - Private Properties

    private var cardsProgressView: some View {
        GeometryReader { geometry in
            if index == 0 {
                ZStack(alignment: .leading) {
                    Rectangle().frame(width: geometry.size.width,
                                      height: 2)
                        .opacity(0.3)
                        .foregroundColor(Color(.lightBlue()))
                    Rectangle()
                        .frame(width: CGFloat(Double(self.index + 1) / Double(viewModel.cardsList.count))
                               * (geometry.size.width),
                               height: 4)
                        .padding(.leading, 0)
                        .foreground(.blue())
                }.cornerRadius(45.0)
            } else if index == viewModel.cardsList.count - 1 {
                ZStack {
                    Rectangle().frame(width: geometry.size.width,
                                      height: 2)
                        .opacity(0.3)
                        .foregroundColor(Color(.lightBlue()))
                    Rectangle()
                        .frame(width: CGFloat(Double(self.index + 1) / Double(viewModel.cardsList.count))
                               * (geometry.size.width),
                               height: 4)
                        .padding(.leading, CGFloat(Double(self.index) / Double(viewModel.cardsList.count))
                                 * (geometry.size.width))
                        .padding(.trailing, 16)
                        .foreground(.blue())
                }.cornerRadius(45.0)
            }
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
                Text(transaction.amount > 0 ? String("+ \(transaction.amount)") + " AUR":
                        String("- \(abs(transaction.amount))") + " AUR")
                    .font(.regular(15))
                    .foreground(transaction.type == .send ? .black(): .green())
                Text(String(transaction.amount) + " USD")
                    .font(.regular(13))
                    .foreground(.darkGray())
            }
        }
            Divider()
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WalletNewView(viewModel: WalletNewViewModel())
    }
}
