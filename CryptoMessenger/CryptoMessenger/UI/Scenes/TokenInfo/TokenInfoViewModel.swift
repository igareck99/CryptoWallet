import Combine
import SwiftUI

// MARK: - TokenInfoViewModel

final class TokenInfoViewModel: ObservableObject {

    // MARK: - Internal Properties

    @State var address: WalletInfo
    @Published var addresses = [WalletInfo(walletType: .aur,
                                           address: "0xSf13S891 ... 3dfasfAgfj1",
                                           coinAmount: 246,
                                           fiatAmount: 1044),
                                WalletInfo(walletType: .aur,
                                           address: "0xh2d38kU ... 9Mfasfbgnb ",
                                           coinAmount: 253,
                                           fiatAmount: 1013)]

    // MARK: - Private Properties

    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Lifecycle

    init(address: WalletInfo) {
        self.address = address
    }

    // MARK: - Internal Methods

    func updateAddress(newAddress: WalletInfo) {
        address = newAddress
        print("edl,del,dl,e   \(address)")
    }

    // MARK: - Private Methods

    private func updateData() {
    }
}
