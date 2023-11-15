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
                        .font(.bodySemibold17)
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
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
