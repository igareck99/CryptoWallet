import SwiftUI

@main
struct CryptoMessengerApp: App {

    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var rootCoordinator = AppCoordinatorAssembly.coordinator
    @ObservedObject var statusBarUseCase = StatusBarCallUseCase.shared
    @ObservedObject var navStackState = AppNavStackState.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navStackState.path) {
                if statusBarUseCase.showCallBar {
                    Text("Phone Call")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.green)
                        .onTapGesture {
                            debugPrint("onTapGesture Phone Call")
                            statusBarUseCase.didTapCallStatusView()
                        }
                }
                rootCoordinator.rootView.anyView()
                    .navigationDestination(
                        for: AppTransitions.self,
                        destination: destinations
                    )
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onChange(of: scenePhase) { phase in
            debugPrint("App phase: \(phase)")
        }
    }

    @ViewBuilder
    private func destinations(link: AppTransitions) -> some View {
        switch link {
            case let .callView(model, p2pCallUseCase):
                P2PCallsAssembly.make(model: model, p2pCallUseCase: p2pCallUseCase)
            default:
                EmptyView()
        }
    }
}
