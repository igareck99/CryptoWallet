import Foundation

// MARK: - AuthResponse

struct AuthResponse: Codable {

    // MARK: - Internal Properties

    let userId: String?
    let accessToken: String
    let refreshToken: String
	let matrixPassword: String?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {

        // MARK: - Types

        case userId = "user_id"
        case accessToken = "jwt"
        case refreshToken = "refresh_token"
		case matrixPassword = "matrix_password"
    }
}

struct AuthJWTResponse: Codable {

    let userId: String?
    let isNewUser: Bool?
    let apiAccessToken: String?
    let apiRefreshToken: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case apiAccessToken = "jwt"
        case apiRefreshToken = "refresh_token"
        case isNewUser = "new_user"
    }
}

struct AuthMatrixJWTResponse: Codable {
    let userId: String?
    let deviceId: String?
    let homeServer: String?
    let accessToken: String?
    // Пока вроде как не нужен этот параметр
//    let wellKnown: [String: Any]?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case deviceId = "device_id"
        case homeServer = "home_server"
        case accessToken = "access_token"
//        case wellKnown = "well_known"
    }
}
