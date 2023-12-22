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
    case invalidCode
    case noRefreshToken
    case publisherCreationFailure
    case noAllApiTokens
    case refreshTokenUpdateFailure
    case apiClientDeallocated
}

// MARK: - APIError (LocalizedError)

extension APIError: LocalizedError {

    // MARK: - Internal Properties

    var errorDescription: String {
        switch self {
        case .notConnectedToInternet:
            return "Плохое интернет соединение"
        case .invalidData:
            return "Не удалось распаковать ответ от сервера"
        case .serverError, .apiError, .clientError:
            return "Что-то пошло не так"
        case .invalidToken:
            return "Срок жизни токена истек. Обновляем.."
        case .invalidCode:
            return "Неверный код"
        case .noRefreshToken:
            return "Нет refresh token, нечем обновить сессию"
        case .noAllApiTokens:
            return "Отсутствуют apiToken и apiRefreshtoken"
        case .refreshTokenUpdateFailure:
            return "Ответ на refresh token 401"
        case .apiClientDeallocated:
            return "Api Client deallocated"
		default: return "Что-то пошло не так"
        }
    }
}
