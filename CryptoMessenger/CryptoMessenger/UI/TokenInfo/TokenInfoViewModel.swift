import Combine
import SwiftUI

protocol TokenInfoViewModelProtocol: ObservableObject {
    var isSnackbarPresented: Bool { get set }
    var addresses: [WalletInfo] { get set }
    var address: WalletInfo { get set }
    var resources: TokenInfoResourcable.Type { get }

    func onAddressCopy()
    func generateQRCode() -> Image
}

final class TokenInfoViewModel {
    @Published var address: WalletInfo
    @Published var addresses = [WalletInfo]()
    @Published var isSnackbarPresented = false
    let resources: TokenInfoResourcable.Type
    private let userCredentialsStorage: UserCredentialsStorage
    private let pasteboardService: PasteboardServiceProtocol
    private let qrCodeService: QRCodeServiceProtocol

    init(
        address: WalletInfo,
        qrCodeService: QRCodeServiceProtocol = QRCodeService(),
        pasteboardService: PasteboardServiceProtocol = PasteboardService(),
        userCredentialsStorage: UserCredentialsStorage = UserDefaultsService.shared,
        resources: TokenInfoResourcable.Type = TokenInfoResources.self
    ) {
        self.address = address
        self.pasteboardService = pasteboardService
        self.qrCodeService = qrCodeService
        self.userCredentialsStorage = userCredentialsStorage
        self.resources = resources
    }
}

// MARK: - TokenInfoViewModelProtocol

extension TokenInfoViewModel: TokenInfoViewModelProtocol {

	func onAddressCopy() {
        pasteboardService.copyToPasteboard(text: address.address)
		isSnackbarPresented = true
		objectWillChange.send()

        delay(3) { [weak self] in
			self?.isSnackbarPresented = false
			self?.objectWillChange.send()
		}
	}

    func generateQRCode() -> Image {
        if let image = qrCodeService.generateQRCode(string: address.address) {
            return image
        }
        return resources.xmarkCircle
    }

    func updateAddress(newAddress: WalletInfo) {
        self.address = newAddress
        self.objectWillChange.send()
    }
}
