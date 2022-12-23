import SwiftUI

// MARK: - WalletAddressScanerView

struct WalletAddressScanerView: View {

    // MARK: - Internal Properties

    @Binding var scannedCode: String
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.qrCodeTitle())
                        .font(.bold(15))
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
