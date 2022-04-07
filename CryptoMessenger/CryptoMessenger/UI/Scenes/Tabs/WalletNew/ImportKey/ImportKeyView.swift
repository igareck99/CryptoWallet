import SwiftUI

// MARK: - ImportKeyView

struct ImportKeyView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ImportKeyViewModel
    @State var isChooseWalletShow = false
    @State var choosedWalletType = WalletType.ethereum
    @State var isSelectedWalletType = false
    @State var showWrongMnemonicAlert = false
    @State var showMnemonicSuccess = false
    @State var showButtonAnimation = false
    @Environment(\.presentationMode) private var presentationMode
    @FocusState var focusValue: Int?

    // MARK: - Private Properties

    @State private var newKey = ""

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Divider()
                    .padding(.top, 16)
                Text(R.string.localizable.importImportKey())
                    .font(.semibold(21))
                    .padding(.top, 50)
                ZStack(alignment: .topLeading) {
                TextEditor(text: $newKey)
                    .padding(.leading, 16)
                    .background(.paleBlue())
                    .foreground(.black())
                    .font(.regular(15))
                    .frame(width: geometry.size.width - 32,
                           height: 100)
                    .cornerRadius(8)
                    .keyboardType(.alphabet)
                    
                    if newKey.isEmpty {
                        Text(R.string.localizable.importEnterPrivateKey())
                            .foreground(.darkGray())
                            .padding(.leading, 17)
                            .padding(.top, 12)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.top, 185)
                ZStack(alignment: .leading) {
                chooseWalletView
                        .onTapGesture {
                            isChooseWalletShow = true
                        }
                }
                .padding(.leading, 16)
                .padding(.trailing, 20)
                .padding(.top, 20)
                Text(R.string.localizable.importHowImportKey())
                    .font(.regular(15))
                    .foreground(.blue())
                    .padding(.top, 79)
                Divider()
                    .padding(.top, 96)
                importButton
                    .padding(.top, 8)
            }
            .hideKeyboardOnTap()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
        }
        .alert(isPresented: $showWrongMnemonicAlert) {
            switch showMnemonicSuccess {
            case true:
                let dismissButton = Alert.Button.default(Text("OK")) {
                    print("previousScreen")
                    presentationMode.wrappedValue.dismiss()
                }
                let alert = Alert(title: Text("Ключ успешно импортирован"),
                                  message: Text(""),
                                  dismissButton: dismissButton)
                return alert
            case false:
                return Alert(title: Text("Ошибка при создании фразы"))
            }
        }
        .popup(isPresented: $isChooseWalletShow,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: Color(.black(0.3))) {
            ChooseWalletTypeView(chooseWalletShow: $isChooseWalletShow,
                                 choosedWalletType: $choosedWalletType,
                                 isSelectedWalletType: $isSelectedWalletType)
                .frame(width: UIScreen.main.bounds.width, height: 242, alignment: .center)
                .background(.white())
                .cornerRadius(16)
        }
        .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(R.string.localizable.importTitle())
                            .font(.bold(15))
                    }
                }
    }

    // MARK: - Private Properties

    private var chooseWalletView: some View {
        HStack {
            HStack(spacing: 16) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.blue(0.1))
                R.image.wallet.wallet.image
            }
                Text(isSelectedWalletType ? choosedWalletType.chooseTitle:
                        R.string.localizable.importChooseWalletType())
                    .font(.semibold(15))
        }
            Spacer()
            R.image.answers.downsideArrow.image
        }
    }

    private var importButton: some View {
        Button {
            showButtonAnimation = true
            viewModel.createWallet(item: newKey,
                                   type: choosedWalletType)
            delay(2) {
                if viewModel.walletError {
                    newKey = ""
                    viewModel.walletError = false
                    showWrongMnemonicAlert = true
                    showMnemonicSuccess = false
                } else {
                    showWrongMnemonicAlert = true
                    showMnemonicSuccess = true
                }
                showButtonAnimation = false
            }
        } label: {
            switch showButtonAnimation {
            case false :
            Text(R.string.localizable.importImport())
                .font(.semibold(15))
                .foreground(newKey.isEmpty || isSelectedWalletType == false
                            ? .darkGray() : .white())
                .frame(width: 185,
                       height: 44)
            case true:
                ProgressView()
                    .tint(Color(.blue()))
                    .frame(width: 12,
                           height: 12)
            }
        }
        .disabled(newKey.isEmpty || isSelectedWalletType == false)
        .frame(minWidth: 185,
               idealWidth: 185,
               maxWidth: 185,
               minHeight: 44,
               idealHeight: 44,
               maxHeight: 44)
        .background(newKey.isEmpty || isSelectedWalletType == false
                    ? Color(.lightGray()) : Color(.blue()) )
        .cornerRadius(8)
    }
}

// MARK: - ChooseWalletTypeCell

struct ChooseWalletTypeCell: View {

    // MARK: - Internal Properties

    var walletType: WalletType

    // MARK: - Body

    var body: some View {
        HStack {
        HStack(alignment: .center,
               spacing: 16) {
            switch walletType {
            case .ethereum:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.purple(0.1))
                R.image.importKey.ethereumLabel.image
                }
                Text("ETH (Ethereum)")
                    .font(.bold(15))
            case .bitcoin:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.lightOrange(0.1))
                R.image.importKey.bitcoinLabel.image
                }
                Text("BTC (Bitcoin)")
                    .font(.bold(15))
            case .aur:
                ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.blue(0.1))
                R.image.chat.logo.image
                }
                Text("AUR (Aura)")
                    .font(.bold(15))
            }
        }               .padding(.leading, 16)
               .frame(height: 64)
            Spacer()
    }
    }
}

// MARK: - ChooseWalletTypeView

struct ChooseWalletTypeView: View {

    // MARK: - Internal Properties

    @Binding var chooseWalletShow: Bool
    @Binding var choosedWalletType: WalletType
    @Binding var isSelectedWalletType: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 31, height: 4)
                .foreground(.darkGray(0.4))
                .padding(.top, 6)
            ForEach([WalletType.bitcoin, WalletType.ethereum, WalletType.aur], id: \.self) { item in
                ChooseWalletTypeCell(walletType: item)
                    .onTapGesture {
                        choosedWalletType = item
                        isSelectedWalletType = true
                        chooseWalletShow.toggle()
                    }
            }
            Spacer()
        }
    }
}
