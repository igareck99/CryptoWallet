import Foundation
import HDWalletKit

protocol KeysServiceProtocol {
	func makeBitcoinKeys(seed: String) -> KeysService.Keys
	func makeEthereumKeys(seed: String) -> KeysService.Keys
}

final class KeysService: KeysServiceProtocol {

	struct Keys {
		let privateKey: String
		let publicKey: String
	}

	func makeBitcoinKeys(seed: String) -> Keys {
		makeKeys(
			coin: .bitcoin,
			seed: seed,
			derivationNodes: [.hardened(44), .hardened(1), .hardened(0), .notHardened(0), .notHardened(0)]
		)
	}

	func makeEthereumKeys(seed: String) -> Keys {
		makeKeys(
			coin: .ethereum,
			seed: seed,
			derivationNodes: [.hardened(44), .hardened(60), .hardened(0), .notHardened(0), .notHardened(0)]
		)
	}

	private func makeKeys(
		coin: Coin,
		seed: String,
		derivationNodes: [DerivationNode]
	) -> Keys {

		let mnemonic = Mnemonic.createSeed(mnemonic: seed)
		var privateKey = PrivateKey(seed: mnemonic, coin: coin)
		derivationNodes.forEach { privateKey = privateKey.derived(at: $0) }

		let privateKeyStr = privateKey.raw.toHexString()
		let droppedPublicKey = String(privateKey.publicKey.uncompressedPublicKey.toHexString().dropFirst(2))
		debugPrint("Keys \(coin.coinType) privateKey: \(privateKeyStr)")
		debugPrint("Keys \(coin.coinType) publicKey: \(droppedPublicKey)")
		debugPrint("Keys \(coin.coinType) end")

		return Keys(
			privateKey: privateKeyStr,
			publicKey: droppedPublicKey
		)
	}
}
