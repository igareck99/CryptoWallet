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
