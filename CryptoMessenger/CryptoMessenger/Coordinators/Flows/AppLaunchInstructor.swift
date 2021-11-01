import Foundation

// MARK: - AppLaunchInstructor

enum AppLaunchInstructor {
    case localAuth
    case authentication
    case main

    // MARK: - Static Methods

    static func configure(isAuthorized: Bool, isLocalAuth: Bool) -> AppLaunchInstructor {
        switch (isAuthorized, isLocalAuth) {
        case (true, true):
            return .localAuth
        case (false, _):
            return .authentication
        case (true, false):
            return .main
        }
    }
}
