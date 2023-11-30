import SwiftUI

protocol WalletRouterable {

    associatedtype State: WalletRouterStatable

    func transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    )
    func popToRoot()
    func previousScreen()
    func navState() -> State
    func routePath() -> Binding<NavigationPath>
    func presentedItem() -> Binding<BaseSheetLink?>
    func showTokenInfo(wallet: WalletInfo)
}

struct WalletRouter<
    Content: View,
    State: WalletRouterStatable,
    Factory: ViewsBaseFactoryProtocol
>: View {

    @ObservedObject var state: State
    let factory: Factory.Type
    var content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(
                    item: $state.presentedItem,
                    content: factory.makeSheet
                )
                .navigationDestination(
                    for: BaseContentLink.self,
                    destination: factory.makeContent
                )
        }
    }
}

// MARK: - WalletRouterable

extension WalletRouter: WalletRouterable {

    func navState() -> State {
        state
    }

    func routePath() -> Binding<NavigationPath> {
        $state.path
    }

    func previousScreen() {
        state.path.removeLast()
    }

    func presentedItem() -> Binding<BaseSheetLink?> {
        $state.presentedItem
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }

    func transaction(
        filterIndex: Int,
        tokenIndex: Int,
        address: String,
        coordinator: WalletCoordinatable
    ) {
        state.path.append(
            BaseContentLink.transaction(
                filterIndex: filterIndex,
                tokenIndex: tokenIndex,
                address: address,
                coordinator: coordinator
            )
        )
    }

    func showTokenInfo(wallet: WalletInfo) {
        state.path.append(
            BaseContentLink.showTokenInfo(wallet: wallet)
        )
    }
}
