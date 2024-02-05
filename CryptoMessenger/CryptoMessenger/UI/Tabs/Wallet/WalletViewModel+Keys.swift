import Foundation

extension WalletViewModel {
    func makeKey(type: CryptoType, seed: String, wallet: WalletNetwork) {
        switch type {
        case .ethereum:
            makeEthereumKeys(seed: seed, wallet: wallet)
        case .binance:
            makeBinanceKeys(seed: seed, wallet: wallet)
        case .bitcoin:
            makeBitcoinKeys(seed: seed, wallet: wallet)
        case .aura:
            makeAuraKeys(seed: seed, wallet: wallet)
        default:
            debugPrint("Unknown result")
        }
    }
    func makeEthereumKeys(seed: String, wallet: WalletNetwork) {
        guard let keys = keysService.makeEthereumKeys(
            seed: seed,
            derivation: wallet.derivePath
        ) else {
            // TODO: Обработать неудачное создание ключей
            return
        }
        keychainService.set(keys.privateKey, forKey: .ethereumPrivateKey)
        keychainService.set(keys.publicKey, forKey: .ethereumPublicKey)
    }

    func makeBinanceKeys(seed: String, wallet: WalletNetwork) {
        guard let keys = keysService.makeBinanceKeys(
            seed: seed,
            derivation: wallet.derivePath
        ) else {
            // TODO: Обработать неудачное создание ключей
            return
        }
        keychainService.set(keys.privateKey, forKey: .binancePrivateKey)
        keychainService.set(keys.publicKey, forKey: .binancePublicKey)
    }

    func makeBitcoinKeys(seed: String, wallet: WalletNetwork) {
        guard let keys = keysService.makeBitcoinKeys(
            seed: seed,
            derivation: wallet.derivePath
        ) else {
            // TODO: Обработать неудачное создание ключей
            return
        }
        keychainService.set(keys.privateKey, forKey: .bitcoinPrivateKey)
        keychainService.set(keys.publicKey, forKey: .bitcoinPublicKey)
    }

    func makeAuraKeys(seed: String, wallet: WalletNetwork) {
        guard let keys = self.keysService.makeEthereumKeys(
            seed: seed,
            derivation: wallet.derivePath
        ) else {
            // TODO: Обработать неудачное создание ключей
            return
        }
        keychainService.set(keys.privateKey, forKey: .auraPrivateKey)
        keychainService.set(keys.publicKey, forKey: .auraPublicKey)
    }
}
