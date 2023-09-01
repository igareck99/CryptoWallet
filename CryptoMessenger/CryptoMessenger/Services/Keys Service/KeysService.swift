import Foundation
import HDWalletKit

// swiftlint:disable all

protocol KeysServiceProtocol {
	func makeBitcoinKeys(seed: String) -> KeysService.Keys
    func makeBitcoinKeys(seed: String, derivation: String?) -> KeysService.Keys?

    func makeBinanceKeys(seed: String) -> KeysService.Keys
    func makeBinanceKeys(seed: String, derivation: String?) -> KeysService.Keys?
    func makeEthereumKeys(seed: String) -> KeysService.Keys
    func makeEthereumKeys(seed: String, derivation: String?) -> KeysService.Keys?
	func signBy(hash: String, privateKey: String) -> String?
	func signBy(utxoHash: String, privateKey: String) -> String?
}

final class KeysService: KeysServiceProtocol {

	private let ellipticSigner = EllipticCurveEncrypterSecp256k1()

	struct Keys {
		let privateKey: String
		let publicKey: String
	}
    
    func makeDerivationNodes(derivation: String) -> [DerivationNode] {
        let numsSet = CharacterSet(charactersIn: "0123456789").inverted
       
        let derivations: [DerivationNode] = derivation
            .components(separatedBy: "/")
            .map { $0.trimmingCharacters(in: numsSet) }
            .compactMap(UInt32.init)
            .map(DerivationNode.hardened)
            .dropLast()
        
        return derivations
    }

	func makeBitcoinKeys(seed: String) -> Keys {
		makeKeys(
			coin: .bitcoin,
			seed: seed,
			derivationNodes: [
				.hardened(44),
				.hardened(1),
				.hardened(0),
				.notHardened(0),
				.notHardened(0)
			]
		)
	}
    
    func makeBitcoinKeys(seed: String, derivation: String?) -> Keys? {
        guard let derivationStr = derivation else { return nil }
        let nodes = makeDerivationNodes(derivation: derivationStr) + [.notHardened(0), .notHardened(0)]
        
        let keys = makeKeys(
            coin: .bitcoin,
            seed: seed,
            derivationNodes: nodes
        )
        
        return keys
    }

	func makeEthereumKeys(seed: String) -> Keys {
		makeKeys(
			coin: .ethereum,
			seed: seed,
			derivationNodes: [
				.hardened(44),
				.hardened(60),
				.hardened(0),
				.notHardened(0),
				.notHardened(0)
			]
		)
	}
    
    func makeEthereumKeys(seed: String, derivation: String?) -> Keys? {
        guard let derivationStr = derivation else { return nil }
        let nodes = makeDerivationNodes(derivation: derivationStr) + [.notHardened(0), .notHardened(0)]
        let keys = makeKeys(
            coin: .ethereum,
            seed: seed,
            derivationNodes: [
                .hardened(44),
                .hardened(60),
                .hardened(0),
                .notHardened(0),
                .notHardened(0)
            ]
        )
        return keys
    }
    
    func makeBinanceKeys(seed: String) -> Keys {
        makeKeys(
            coin: .ethereum,
            seed: seed,
            derivationNodes: [
                .hardened(44),
                .hardened(60),
                .hardened(0),
                .notHardened(0),
                .notHardened(0)
            ]
        )
    }
    
    func makeBinanceKeys(seed: String, derivation: String?) -> Keys? {
        guard let derivationStr = derivation else { return nil }
        let nodes = makeDerivationNodes(derivation: derivationStr) + [.notHardened(0), .notHardened(0)]
        
        let keys = makeKeys(
            coin: .ethereum,
            seed: seed,
            derivationNodes: [
                .hardened(44),
                .hardened(60),
                .hardened(0),
                .notHardened(0),
                .notHardened(0)
            ]
        )
        return keys
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

	func signBy(hash: String, privateKey: String) -> String? {
		let utxoData = Data(hex: hash)
		let privateKeyData = Data(hex: privateKey)

		guard
			var signature = ellipticSigner.sign(
				hash: utxoData,
				privateKey: privateKeyData
			)
		else {
			return nil
		}

		let result = ellipticSigner.export(signature: &signature)
		let res_str_1 = String(data: result, encoding: .utf8)
		let res_str_2 = result.toHexString()
		let res_str_3 = result.dataToHexString()

		debugPrint("RESULT_NSDATA: \(result as NSData)")
		debugPrint("RESULT_1: \(res_str_1)")
		debugPrint("RESULT_2: \(res_str_2)")
		debugPrint("RESULT_3: \(res_str_3)")
		debugPrint("END")

		return res_str_3
	}

	func signBy(utxoHash: String, privateKey: String) -> String? {

		let utxoData = Data(hex: utxoHash)
		let privateKeyData = Data(hex: privateKey)

		guard
			let result = try? ECDSA.sign(utxoData, privateKey: privateKeyData)
		else {
			return nil
		}

		let res_str_1 = String(data: result, encoding: .utf8)
		let res_str_2 = result.toHexString()
		let res_str_3 = result.dataToHexString()

		debugPrint("RESULT_NSDATA: \(result as NSData)")
		debugPrint("RESULT_1: \(res_str_1)")
		debugPrint("RESULT_2: \(res_str_2)")
		debugPrint("RESULT_3: \(res_str_3)")
		debugPrint("END")

		return res_str_3
	}
}