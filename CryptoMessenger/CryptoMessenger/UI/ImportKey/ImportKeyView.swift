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
                    text: viewModel.resources.phraseManagerKeyImportSucces,
                    color: viewModel.resources.snackbarBackground
                )
            }
            .popup(isPresented: $isChooseWalletShow,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: viewModel.resources.backgroundFodding) {
                ChooseWalletTypeView(
                    chooseWalletShow: $isChooseWalletShow,
                    choosedWalletType: $choosedWalletType,
                    isSelectedWalletType: $isSelectedWalletType,
                    wallletTypes: viewModel.walletTypes
                )
                .frame(width: UIScreen.main.bounds.width, height: 242, alignment: .center)
                .background(viewModel.resources.background)
                .cornerRadius(16)
            }
                   .alert(isPresented: $showMnemonicSuccess) { () -> Alert in
                       let dismissButton = Alert.Button.default(Text("OK")) {
                           presentationMode.wrappedValue.dismiss()
                       }
                       let alert = Alert(title: Text(viewModel.resources.generatePhraseSaved),
                                         message: Text(""),
                                         dismissButton: dismissButton)
                       return alert
                   }
                   .toolbar {
                       ToolbarItem(placement: .principal) {
                           Text(viewModel.resources.importTitle)
                               .font(.bodySemibold17)
                       }
                   }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(spacing: 0) {
            Text(viewModel.resources.keyImportTitle)
                .font(.title2Regular22)
                .padding(.top, 59)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.newKey)
                    .focused($inputViewIsFocused)
                    .padding(.leading, 16)
                    .background(viewModel.resources.textBoxBackground)
                    .foregroundColor(viewModel.resources.titleColor)
                    .font(.bodyRegular17)
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .keyboardType(.alphabet)
                    .scrollContentBackground(.hidden)
                if viewModel.newKey.isEmpty {
                    Text(viewModel.resources.importEnterPrivateKey)
                        .foregroundColor(viewModel.resources.textColor)
                        .font(.bodyRegular17)
                        .padding(.leading, 20)
                        .padding(.top, 12)
                        .disabled(true)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.resources.negativeColor, lineWidth: 1)
                    .opacity(viewModel.isErrorState ? 1 : 0)
                    .padding(.horizontal, 16)
            }
            .padding(.top, 24)

            HStack {
                Text(viewModel.resources.generatePhraseErrorKey)
                    .foregroundColor(viewModel.resources.negativeColor)
                    .font(.caption1Regular12)
                    .opacity(viewModel.isErrorState ? 1 : 0)
                    .padding(.top, 4)
                    .padding(.leading, 16)
                Spacer()
            }

            Text(viewModel.resources.importHowImportKey)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.buttonBackground)
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
                    .foregroundColor(viewModel.resources.avatarBackground)
                viewModel.resources.walletImage
            }
                Text(isSelectedWalletType ? choosedWalletType.currency :
                        viewModel.resources.importChooseWalletType)
                    .font(.bodySemibold17)
        }
            Spacer()
            viewModel.resources.downSideArrowImage
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
                Text(viewModel.resources.importImport)
                    .font(.bodySemibold17)
                    .foregroundColor(viewModel.isPhraseValid ? viewModel.resources.background : viewModel.resources.textColor)
                    .padding()
            case true:
                ProgressView()
                    .tint(viewModel.resources.background)
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
                    viewModel.resources.buttonBackground :
                        viewModel.resources.innactiveButtonBackground
                )
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 69)
        )
    }
}
