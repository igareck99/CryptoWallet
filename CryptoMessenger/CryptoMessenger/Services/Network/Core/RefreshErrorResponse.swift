import Foundation

struct RefreshErrorResponse: Codable {
    let type: String// "InvalidRefreshToken",
    let code: Int // 20007,
    let message: String // "Invalid refresh token."
}

enum ResponseErrorType: String {
    case invalidRefreshToken = "InvalidRefreshToken"
}

// "{"type":"InvalidRefreshToken","code":20007,"message":"Invalid refresh token."}"
