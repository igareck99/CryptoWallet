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
    @FocusState var inputViewIsFocused: Bool

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
            .popup(
                isPresented: viewModel.isSnackbarPresented,
                alignment: .bottom
            ) {
                Snackbar(
                    text: "Ключ импортирован",
                    color: .green
                )
            }
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
                               .font(.system(size: 17, weight: .semibold))
                       }
                   }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(spacing: 0) {
            Text(R.string.localizable.keyImportTitle())
                .font(.system(size: 22))
                .padding(.top, 59)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.newKey)
                    .focused($inputViewIsFocused)
                    .padding(.leading, 16)
                    .background(.paleBlue())
                    .foreground(.black())
                    .font(.system(size: 17))
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .keyboardType(.alphabet)
                    .scrollContentBackground(.hidden)
                if viewModel.newKey.isEmpty {
                    Text(R.string.localizable.importEnterPrivateKey())
                        .foreground(.darkGray())
                        .font(.system(size: 17))
                        .padding(.leading, 20)
                        .padding(.top, 12)
                        .disabled(true)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: 1)
                    .opacity(viewModel.isErrorState ? 1 : 0)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 24)

            HStack {
                Text(R.string.localizable.generatePhraseErrorKey())
                    .foreground(.red())
                    .font(.system(size: 12, weight: .light))
                    .opacity(viewModel.isErrorState ? 1 : 0)
                    .padding(.top, 4)
                    .padding(.leading, 16)
                Spacer()
            }

            Text(R.string.localizable.importHowImportKey())
                .font(.system(size: 15))
                .foreground(.blue())
                .padding(.top, 8)
            
            importButton
                .padding([.top, .bottom], 32)

            Spacer()
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
            inputViewIsFocused = false
            showButtonAnimation = true
            viewModel.createWallet(item: viewModel.newKey)
            delay(2) {
                if viewModel.isPhraseValid {
                    viewModel.newKey = ""
                    viewModel.isPhraseValid = false
                    showMnemonicSuccess = false
                    showButtonAnimation = false
                    viewModel.onAddressImported()
                } else {
                    showMnemonicSuccess = true
                    showButtonAnimation = false
                }
            }
        } label: {
            switch showButtonAnimation {
            case false:
                Text(R.string.localizable.importImport())
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(viewModel.isPhraseValid ? .white : .bombayApprox)
                    .padding()
            case true:
                ProgressView()
                    .tint(.white)
                    .frame(width: 12, height: 12)
            }
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 69)
        .disabled(!viewModel.isPhraseValid)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    viewModel.isPhraseValid ?
                    Color.azureRadianceApprox :
                        Color.blackHazeApprox
                )
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 69)
        )
    }
}
