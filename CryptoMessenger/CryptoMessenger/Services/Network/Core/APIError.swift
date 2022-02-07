import Foundation

// MARK: - APIError

enum APIError: Error {

    // MARK: - Types

    case notConnectedToInternet
    case serverError
    case clientError
    case apiError(Int, Data?)
}

// MARK: - APIError (LocalizedError)

extension APIError: LocalizedError {

    // MARK: - Private Properties

    var errorDescription: String? {
        switch self {
        case .notConnectedToInternet:
            return "Плохое интернет соединение"
        case .serverError, .apiError, .clientError:
            return "Что-то пошло не так"
        }
    }
}
