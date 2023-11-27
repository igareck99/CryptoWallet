import Bip39
import Foundation
import HDWalletKit

// swiftlint:disable:all

// MARK: - PhraseServiceProtocol

protocol PhraseServiceProtocol {
    func validateSecretPhrase(phrase: String) -> Bool
    func createMnemonicPhrase() -> String
}

// MARK: - PhraseService

final class PhraseService: PhraseServiceProtocol {

    // MARK: - Internal Properties

    static let shared = PhraseService()

    // MARK: - Internal Methods

    func validateSecretPhrase(phrase: String) -> Bool {
        let seed: [String] = phrase.split(separator: " ").map(String.init)
        let isValid = Bip39.Mnemonic.isValid(phrase: seed)
        return isValid
    }

    func createMnemonicPhrase() -> String {
        let phrase = HDWalletKit.Mnemonic.create()
        return phrase
    }
}
