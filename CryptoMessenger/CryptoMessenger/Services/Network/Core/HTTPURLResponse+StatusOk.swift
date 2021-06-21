import Foundation

// MARK: HTTPURLResponse ()

extension HTTPURLResponse {

    // MARK: - Internal Properties

    var isOk: Bool { statusCode >= 200 && statusCode < 300 }
}
