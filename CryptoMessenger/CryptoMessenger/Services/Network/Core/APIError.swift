import Foundation

// MARK: - APIError

struct APIError: Error {

    // MARK: - Internal Properties

    let statusCode: Int
    let data: Data?
}
