import SwiftUI

// MARK: - WalletAddressScanerView

struct WalletAddressScanerView: View {

    // MARK: - Internal Properties

    @Binding var scannedCode: String
    @StateObject var viewModel: WalletAddressScanerViewModel
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.resources.qrCodeTitle)
                        .font(.system(size: 15, weight: .bold))
                }
            }
            .onChange(of: scannedCode) { newValue in
                if !newValue.isEmpty {
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack {
            CodeScannerView(codeTypes: [.qr]) { response in
                if case let .success(result) = response {
                    if scannedCode != result.string {
                        scannedCode = result.string
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
