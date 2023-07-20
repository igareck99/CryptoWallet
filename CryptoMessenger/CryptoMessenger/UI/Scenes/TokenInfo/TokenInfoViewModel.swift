import Combine
import SwiftUI

// MARK: - TokenInfoViewModel

final class TokenInfoViewModel: ObservableObject {

    // MARK: - Internal Properties

    @State var address: WalletInfo
    @Published var addresses = [WalletInfo]()
	var isSnackbarPresented = false
    let resources: TokenInfoResourcable.Type = TokenInfoResources.self

    // MARK: - Private Properties

    private let userCredentialsStorage: UserCredentialsStorage

    // MARK: - Lifecycle

    init(
		address: WalletInfo,
		userCredentialsStorage: UserCredentialsStorage,
        resources: TokenInfoResourcable.Type = TokenInfoResources.self
	) {
        self.address = address
		self.userCredentialsStorage = userCredentialsStorage
    }

	func onAddressCopy() {
		isSnackbarPresented = true
		objectWillChange.send()

		DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
			self?.isSnackbarPresented = false
			self?.objectWillChange.send()
		}
	}

    // MARK: - Internal Methods

    func updateAddress(newAddress: WalletInfo) {
        self.address = newAddress
        self.objectWillChange.send()
    }

    // MARK: - Private Methods

    private func updateData() {
    }
}
