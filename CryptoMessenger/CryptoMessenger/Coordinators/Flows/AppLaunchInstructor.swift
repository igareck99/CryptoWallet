import Foundation

// MARK: - AppLaunchInstructor

enum AppLaunchInstructor {
    case localAuth
    case authentication
    case main

    // MARK: - Static Methods

    static func configure(isAuthorized: Bool, isLocalAuth: Bool) -> AppLaunchInstructor {
        switch (isAuthorized, isLocalAuth) {
        case (_, true):
            return .localAuth
        case (_, false):
            return .authentication
        case (true, _):
            return .main
        }
    }
}
