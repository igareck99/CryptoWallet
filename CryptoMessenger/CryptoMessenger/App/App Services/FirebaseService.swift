import Firebase

protocol FirebaseServiceProtocol {
	func configure()
}

final class FirebaseService: NSObject, UIApplicationDelegate {}

// MARK: - FirebaseServiceProtocol

extension FirebaseService: FirebaseServiceProtocol {

	func configure() {
		FirebaseApp.configure()
	}
}
