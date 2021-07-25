import Foundation

// MARK: - AppLaunchInstructor

enum AppLaunchInstructor {
    case authentication
    case onboarding
    case main

    // MARK: - Static Methods

    static func configure(isOnboardingShown: Bool, isAuthorized: Bool) -> AppLaunchInstructor {
        switch (isOnboardingShown, isAuthorized) {
        case (true, false), (false, false):
            return .authentication
        case (false, true):
            return .onboarding
        case (true, true):
            return .main
        }
    }
}
