import Foundation
import HDWalletKit

// MARK: - PhraseService

final class PhraseService: PhraseServiceProtocol {

    // MARK: - Internal Properties

    static let shared = PhraseService()

    // MARK: - Internal Methods

    func validateSecretPhrase(phrase: String, completion: @escaping (Bool) -> Void) {
        let seed = phrase.split(separator: " ")
        var result = false
        if seed.count != 12 {
            result = true
        }
        seed.map { word in
            if !WordList.english.words.contains(where: { $0 == word }) {
                result = true
            }
        }
        completion(result)
    }

    func createMnemonicPhrase(completion: @escaping (String) -> Void) {
        var words: [String] = []
        for _ in 1...12 {
            let randomInt = Int.random(in: 0..<2047)
            print(randomInt)
            words.append(WordList.english.words[randomInt])
            words.shuffle()
        }
        completion(words.joined(separator: " "))
    }

}

// MARK: - PhraseServiceProtocol

protocol PhraseServiceProtocol {
    func validateSecretPhrase(phrase: String, completion: @escaping (Bool) -> Void)
    func createMnemonicPhrase(completion: @escaping (String) -> Void)
}
