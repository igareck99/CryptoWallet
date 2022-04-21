import UIKit

// MARK: - AppDependenciesService

final class AppDependenciesService: NSObject, UIApplicationDelegate {

    // MARK: - Lifecycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        addDependencies()

        return true
    }

    private func addDependencies() {
        DependencyContainer {
            Dependency { APIClient() }
            Dependency { Configuration() }
            Dependency { MatrixStore() }
            Dependency { CountdownTimer(seconds: PhoneHelper.verificationResendTime) }
            Dependency { ContactsManager() }
        }.build()
    }
}
