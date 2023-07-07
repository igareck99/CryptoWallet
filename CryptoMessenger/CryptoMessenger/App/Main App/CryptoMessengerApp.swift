import SwiftUI

// @main
struct CryptoMessengerApp: App {

    @Environment(\.window) private var window: UIWindow? // = WindowKey.defaultValue
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var rootCoordinator = AppCoordinatorAssembly.coordinator

    var body: some Scene {
        WindowGroup {
            rootCoordinator.rootView.anyView()
        }
        .onChange(of: scenePhase) { phase in
            debugPrint("App phase: \(phase)")
        }
    }
}
