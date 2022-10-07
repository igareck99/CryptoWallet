import Foundation

// MARK: - AppLaunchInstructor

enum AppLaunchInstructor: CustomStringConvertible {
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

	public var description: String {
		switch self {
		case .localAuth:
			return "localAuth"
		case .authentication:
			return "authentication"
		case .main:
			return "main"
		@unknown default:
			return "\(self)"
		}
	}
}
