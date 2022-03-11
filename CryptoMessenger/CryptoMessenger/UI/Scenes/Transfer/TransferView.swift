import SwiftUI

// MARK: - TransferView

struct TransferView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: TransferViewModel
    @State var dollarCourse = 120.24
    @State var isButtonActive = true
    @State var isContactChoose = true
    @State var showCoinSelector = false
    @State var isSelectedWalletType = false
    @State var value = 0
    @State private var username: String = ""
    @State var coinType = WalletInfo(walletType: .aur,
                                     adress: "0xSf13S891 ... 3dfasfAgfj1 ",
                                     coinAmount: 256.41948,
                                     fiatAmount: 256.41948)
    private var numberFormatter: NumberFormatterProtocol

    // MARK: - Lifecycle

    init(numberFormatter: NumberFormatter = NumberFormatter(),
         viewModel: TransferViewModel) {
        self.viewModel = viewModel
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.numberStyle = .decimal
        self.numberFormatter.maximumFractionDigits = 4
    }

    // MARK: - Body

    var body: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading) {
//                Divider()
//                    .padding(.top, 16)
//                Text(R.string.localizable.transferYourAdress().uppercased())
//                    .font(.bold(12))
//                    .foreground(.darkGray())
//                    .padding(.leading, 16)
//                    .padding(.top, 24)
//                addressCell
//                    .background(.white())
//                    .padding(.top, 11)
//                    .padding(.horizontal, 16)
//                Text(R.string.localizable.transferToWhom().uppercased())
//                    .font(.bold(12))
//                    .foreground(.darkGray())
//                    .padding(.leading, 16)
//                    .padding(.top, 26)
//                chooseContactCell
//                    .background(.white())
//                    .padding(.top, 12)
//                    .padding(.horizontal, 16)
//                Divider()
//                    .padding(.top, 24)
//                Text(R.string.localizable.transferSum().uppercased())
//                    .font(.bold(12))
//                    .foreground(.darkGray())
//                    .padding(.leading, 16)
//                    .padding(.top, 24)
//                transferCell
//                    .hideKeyboardOnTap()
//                    .padding(.leading, 16)
//                    .padding(.trailing, 21)
//                    .padding(.top, 21)
//                Text(R.string.localizable.transferInDollar() + "\(dollarCourse) USD")
//                    .foreground(.darkGray())
//                    .font(.regular(12))
//                    .padding(.leading, 16)
//                    .padding(.top, 19)
//                transactionCost
//                    .padding(.top, 16)
//                    .padding(.leading, 16)
//            }
//            Spacer()
//            VStack(spacing: 8) {
//                Divider()
//                sendButton
//                    .frame(width: 213,
//                           height: 44)
//            }
//        }
        content
        .popup(isPresented: $showCoinSelector,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: Color(.black(0.3))) {
            ChooseWalletTypeView(chooseWalletShow: $showCoinSelector,
                                 choosedWalletType: $coinType.walletType,
                                 isSelectedWalletType: $isSelectedWalletType)
                .frame(width: UIScreen.main.bounds.width, height: 242, alignment: .center)
                .background(.white())
                .cornerRadius(16)
        }
        .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.transferTransfer())
                        .font(.bold(15))
                }
            }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            Divider()
                .padding(.top, 16)
            VStack(alignment: .leading, spacing: 12) {
                Text(R.string.localizable.transferYourAdress().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                addressCell
                    .background(.white())
                    .padding(.top, 11)
                    .padding(.horizontal, 16)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(R.string.localizable.transferToWhom().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                chooseContactCell
                    .background(.white())
                    .padding(.horizontal, 16)
            }
            .padding(.top, 4)
            Divider()
            
            VStack(alignment: .leading, spacing: 21) {
                Text(R.string.localizable.transferSum().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                transferCell
                    .padding(.horizontal, 16)
                Text(R.string.localizable.transferInDollar() + "\(dollarCourse) USD")
                    .foreground(.darkGray())
                    .font(.regular(12))
                    .padding(.leading, 16)
                    .padding(.top, -5)
            }
            Spacer()
            VStack(spacing: 8) {
                Divider()
                sendButton
                    .frame(width: 213,
                           height: 44)
            }
        }
    }

    private var addressCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(coinType.adress)
                        .font(.medium(15))
                        .frame(height: 22)
                    Text(String(coinType.coinAmount) + " \(coinType.result.currency)")
                        .font(.regular(12))
                        .foreground(.darkGray())
                        .frame(height: 20)
                }
            }
            Spacer()
            R.image.profileDetail.arrow.image
                .frame(width: 20,
                       height: 20,
                       alignment: .center)
        }
    }

    private var chooseContactCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.chat.action.contact.image
                }
                Text(R.string.localizable.transferChooseContact())
                    .foregroundColor(.black)
                    .font(.medium(15))
                    .frame(height: 22)
            }
            Spacer()
            R.image.profileDetail.arrow.image
                .frame(width: 20,
                       height: 20,
                       alignment: .center)
        }
    }

    private var transferCell: some View {
        HStack {
//            VStack {
//                CurrencyTextField(numberFormatter: numberFormatter as! NumberFormatter,
//                                  value: $value)
//                    .frame(width: 152, height: 24)
//            }
            Spacer()
            HStack(spacing: 12) {
                Text("AUR")
                    .font(.medium(24))
                R.image.answers.downsideArrow.image
            }
            .onTapGesture {
                showCoinSelector = true
            }
        }
    }

    private var sendButton: some View {
        Button {
        } label: {
            Text("Отправить")
                .frame(minWidth: 0, maxWidth: 214)
                .font(.semibold(15))
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

    private var transactionCost: some View {
        HStack(spacing: 0) {
            TransactionSpeedView(viewModel: viewModel,
                                 transfer: TransferSpeed.slow)
            middleTransactionCost
            TransactionSpeedView(viewModel: viewModel,
                                 transfer: TransferSpeed.quick)
        }
        .overlay(
                RoundedRectangle(cornerRadius: 4)
                .stroke(Color(.darkGray()), lineWidth: 1)
            )
    }

    private var middleTransactionCost: some View {
        Button {
            viewModel.updateTransactionSpeed(item: .middle)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(TransferSpeed.middle.result.speed)
                    .foreground(TransferSpeed.middle == viewModel.currentSpeed ? .white() : .darkBlack())
                    .font(.medium(12))
                Text(String(TransferSpeed.middle.result.balance) + " ETH")
                    .font(.regular(12))
                    .foreground(TransferSpeed.middle == viewModel.currentSpeed ? .white() : .darkGray())
            }
            .frame(width: 82)
        }
        .frame(width: 125, height: 48)
        .background(TransferSpeed.middle == viewModel.currentSpeed ? Color(.blue()) : Color(.white()))
        .background(RoundedRectangle(cornerRadius: 0).stroke(Color(.darkGray())))
    }
}

// MARK: - TransferView

struct TransactionSpeedView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: TransferViewModel
    @State var transfer: TransferSpeed

    // MARK: - Body

    var body: some View {
        Button {
            viewModel.updateTransactionSpeed(item: transfer)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(transfer.result.speed)
                    .foreground(transfer == viewModel.currentSpeed ? .white() : .darkBlack())
                    .font(.medium(12))
                Text(String(transfer.result.balance) + " ETH")
                    .font(.regular(12))
                    .foreground(transfer == viewModel.currentSpeed ? .white() : .darkGray())
            }
            .frame(width: 82)
        }
        .frame(width: 125, height: 48)
        .background(transfer == viewModel.currentSpeed ? Color(.blue()) : Color(.white()))
    }
}

// MARK: - TransferSpeed

enum TransferSpeed {

    case slow
    case middle
    case quick

    // MARK: - Internal Properties

    var result: (balance: Double,
                 speed: String) {
        switch self {
        case .slow:
            return  (0.0002, R.string.localizable.transferSlow())
        case .middle:
            return  (0.0004, R.string.localizable.transferMiddle())
        case .quick:
            return (0.0008, R.string.localizable.transferQuick())
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
