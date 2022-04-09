import Foundation

// MARK: - APIError

enum APIError: Error, Equatable {

    // MARK: - Types

    case notConnectedToInternet
    case serverError
    case clientError
    case invalidData
    case apiError(Int, Data?)
    case invalidToken
}

// MARK: - APIError (LocalizedError)

extension APIError: LocalizedError {

    // MARK: - Internal Properties

    var errorDescription: String? {
        switch self {
        case .notConnectedToInternet:
            return "Плохое интернет соединение"
        case .invalidData:
            return "Не удалось распаковать ответ от сервера"
        case .serverError, .apiError, .clientError:
            return "Что-то пошло не так"
        case .invalidToken:
            return "Срок жизни токена истек. Обновляем.."
        }
    }
}
