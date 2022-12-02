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

/*
 // Bitcoin (mainnet)
 val mnemonic = "trade icon company use feature fee order double inhale gift news long".split(" ")

 val expectedPublicKey =
 "79cd29633692cbd27c450b2e838a2365f3351f1afa76784ed899a53710a2c36e2ba2adeb0de7ddda39bcd6eea132248addec19147234897bbc8efc6eb44940ba"
 val expectedPrivateKey = "2026bb5bb1e6136e8aa885eefc31828478be521036619c9e594421799f74f237"
 val keyPair = CryptoHelperImpl().generateKeyPair(mnemonic, "m/44'/0'/0'/0/0")

 assertEquals(expectedPublicKey, Hex.toHexString(keyPair.publicKey.toByteArray()))
 assertEquals(expectedPrivateKey, Hex.toHexString(keyPair.privateKey.toByteArray()))
 */


/*
 // Ethereum
 val mnemonic = "trade icon company use feature fee order double inhale gift news long".split(" ")

 val expectedPublicKey =
 "27ca46e54bedd9a5687d3d3bbfa6c854a43ccb60f1f96c7df28e61acda9513e0c8e5f6a9101b87e688370d91f9d813a62cbdea438c2b7b776a5bbd468d4c8bda"
 val expectedPrivateKey = "396f7f85659d2b43ef05f7abc80586aa3989e8ef7218433350ddd5945f7f9008"
 val keyPair = CryptoHelperImpl().generateKeyPair(mnemonic, "m/44'/60'/0'/0/0")

 assertEquals(expectedPublicKey, Hex.toHexString(keyPair.publicKey.toByteArray()))
 assertEquals(expectedPrivateKey, Hex.toHexString(keyPair.privateKey.toByteArray()))
 */
