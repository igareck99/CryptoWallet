import Foundation
import HDWalletKit
import Bip39

// swiftlint:disable:all

// MARK: - PhraseServiceProtocol

protocol PhraseServiceProtocol {
    func validateSecretPhrase(phrase: String) -> Bool
    func createMnemonicPhrase(completion: @escaping (String) -> Void)
}

// MARK: - PhraseService

final class PhraseService: PhraseServiceProtocol {
    
    // MARK: - Internal Properties
    
    static let shared = PhraseService()
    
    // MARK: - Internal Methods
    
    func validateSecretPhrase(phrase: String) -> Bool {
        
//        let testPhrase = "trade icon company use feature fee order double inhale gift news long"
        
        let seed: [String] = phrase.split(separator: " ").map(String.init)
        
        let isValid = Bip39.Mnemonic.isValid(phrase: seed)
        
        debugPrint("validateSecretPhrase: isValid: \(isValid) \(phrase)")
        
        return isValid
    }
    
    func createMnemonicPhrase(completion: @escaping (String) -> Void) {
        var words: [String] = []
        for _ in 1...12 {
            let randomInt = Int.random(in: 0..<2047)
            words.append(WordList.english.words[randomInt])
            words.shuffle()
        }
        completion(words.joined(separator: " "))
    }
}
