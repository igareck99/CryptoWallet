import SwiftUI

// MARK: - ImportKeyView

struct ImportKeyView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ImportKeyViewModel
    @State var isChooseWalletShow = false
    @State var choosedWalletType = WalletType.ethereum
    @State var isSelectedWalletType = false
    @State var showMnemonicSuccess = false
    @State var showButtonAnimation = false
    @Environment(\.presentationMode) private var presentationMode
    @FocusState var focusValue: Int?

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
                UITextView.appearance().backgroundColor = .clear
                UITextView.appearance().textContainerInset = .init(top: 12, left: 0, bottom: 12, right: 0)
            }
            .hideKeyboardOnTap()
            .toolbar(.visible)
            .popup(isPresented: $isChooseWalletShow,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: Color(.black(0.3))) {
                ChooseWalletTypeView(
                    chooseWalletShow: $isChooseWalletShow,
                    choosedWalletType: $choosedWalletType,
                    isSelectedWalletType: $isSelectedWalletType,
                    wallletTypes: viewModel.walletTypes
                )
                .frame(width: UIScreen.main.bounds.width, height: 242, alignment: .center)
                .background(.white())
                .cornerRadius(16)
            }
                   .alert(isPresented: $showMnemonicSuccess) { () -> Alert in
                       let dismissButton = Alert.Button.default(Text("OK")) {
                           presentationMode.wrappedValue.dismiss()
                       }
                       let alert = Alert(title: Text("Фраза сохранена"),
                                         message: Text(""),
                                         dismissButton: dismissButton)
                       return alert
                   }
                   .toolbar {
                       ToolbarItem(placement: .principal) {
                           Text(R.string.localizable.importTitle())
                               .font(.bold(15))
                       }
                   }
    }

    // MARK: - Private Properties

    private var content: some View {
        GeometryReader { geometry in
            VStack {
                Divider()
                    .padding(.top, 16)
                Text(R.string.localizable.keyImportTitle())
                    .font(.regular(22))
                    .padding(.top, 46)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.newKey)
                    .padding(.leading, 16)
                    .background(.paleBlue())
                    .foreground(.black())
                    .font(.regular(15))
                    .frame(width: geometry.size.width - 32,
                           height: 160)
                    .cornerRadius(8)
                    .keyboardType(.alphabet)
                    .scrollContentBackground(.hidden)
                    if viewModel.newKey.isEmpty {
                        Text(R.string.localizable.importEnterPrivateKey())
                            .foreground(.darkGray())
                            .font(.regular(15))
                            .padding(.leading, 17)
                            .padding(.top, 12)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                               .stroke(Color.red, lineWidth: 1)
                               .opacity(viewModel.walletError ? 1 : 0)
                }
                .padding(.top, 24)
                HStack {
                    Text(R.string.localizable.generatePhraseErrorKey())
                        .foreground(.red())
                        .font(.regular(12))
                        .opacity(viewModel.walletError ? 1 : 0)
                        .padding(.top, 4)
                        .padding(.leading, 16)
                    Spacer()
                }
                Text(R.string.localizable.importHowImportKey())
                    .font(.regular(15))
                    .foreground(.blue())
                    .padding(.top, 8)
                importButton
                    .padding([.top, .bottom], 32)
            }
        }
    }

    private var chooseWalletView: some View {
        HStack {
            HStack(spacing: 16) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foreground(.blue(0.1))
                R.image.wallet.wallet.image
            }
                Text(isSelectedWalletType ? choosedWalletType.chooseTitle :
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
            viewModel.createWallet(item: viewModel.newKey)
            delay(2) {
                if viewModel.walletError {
                    viewModel.newKey = ""
                    viewModel.walletError = false
                    showMnemonicSuccess = false
                } else {
                    showMnemonicSuccess = true
                    showButtonAnimation = false
                }
            }
            } label: {
                switch showButtonAnimation {
            case false:
            Text(R.string.localizable.importImport())
                .font(.semibold(15))
                .foreground(!viewModel.walletError ? .white() : .darkGray())
                .frame(width: 185,
                       height: 44)
            case true:
                ProgressView()
                    .tint(Color(.white()))
                    .frame(width: 12,
                           height: 12)
            }
        }
        .disabled(viewModel.walletError)
        .frame(minWidth: 185,
               idealWidth: 185,
               maxWidth: 185,
               minHeight: 44,
               idealHeight: 44,
               maxHeight: 44)
        .background(!viewModel.walletError ? Color(.blue()) : Color(.lightGray()))
        .cornerRadius(8)
    }
}
