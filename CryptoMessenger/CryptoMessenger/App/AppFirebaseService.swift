import Firebase

// MARK: - AppFirebaseService

final class AppFirebaseService: NSObject, UIApplicationDelegate {

    // MARK: - Lifecycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
