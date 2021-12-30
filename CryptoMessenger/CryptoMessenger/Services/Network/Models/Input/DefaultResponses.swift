import Foundation

// MARK: - EmptyResponse

struct EmptyResponse: Codable {}

// MARK: - DictionaryResponse

struct DictionaryResponse {

    // MARK: - Internal Properties

    let dictionary: [String: String]

    // MARK: - Lifecycle

    init(_ dictionary: [String: String]) {
        self.dictionary = dictionary
    }
}
