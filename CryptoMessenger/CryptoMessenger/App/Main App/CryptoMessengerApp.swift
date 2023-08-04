import SwiftUI

@main
struct CryptoMessengerApp: App {

//    @Environment(\.window) private var window: UIWindow? // = WindowKey.defaultValue
//    @EnvironmentObject var sceneDelegate: SceneDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var rootCoordinator = AppCoordinatorAssembly.coordinator

    var body: some Scene {
        WindowGroup {
            rootCoordinator.rootView.anyView()
        }
    }
}
