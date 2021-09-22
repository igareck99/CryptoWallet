import Foundation

// MARK: - AppLaunchInstructor

enum AppLaunchInstructor {
    case authentication
    case onboarding
    case main
    case localauth

    // MARK: - Static Methods

    static func configure(isOnboardingShown: Bool, isAuthorized: Bool, isLocalAuth: Bool) -> AppLaunchInstructor {
        switch (isOnboardingShown, isAuthorized, isLocalAuth) {
        case (true, false, false), (false, false, false):
            return .authentication
        case (false, true, false):
            return .onboarding
        case (true, true, false):
            return .main
        case (true, true, true), (false, _, true), (_, false, true):
            return .localauth
        }
    }
}
