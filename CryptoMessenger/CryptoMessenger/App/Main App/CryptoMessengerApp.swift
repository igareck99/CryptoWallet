import SwiftUI

@main
struct CryptoMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var rootCoordinator = AppCoordinatorAssembly.coordinator

    var body: some Scene {
        WindowGroup {
            rootCoordinator.rootView.anyView()
            //ChatView(viewModel: ChatViewModel())
        }
    }
}
