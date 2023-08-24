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
    func presentedItem() -> Binding<WalletSheetLink?>
    func showTokenInfo(wallet: WalletInfo)
}

struct WalletRouter<Content: View, State: WalletRouterStatable>: View {

    @ObservedObject var state: State

    var content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(item: $state.presentedItem, content: sheetContent)
                .navigationDestination(
                    for: WalletContentLink.self,
                    destination: linkDestination
                )
        }
    }

    @ViewBuilder
    private func linkDestination(link: WalletContentLink) -> some View {
        switch link {
        case let .transaction(filterIndex, tokenIndex, address, coordinator):
            TransactionConfigurator.build(
                selectorFilterIndex: filterIndex,
                selectorTokenIndex: tokenIndex,
                address: address,
                coordinator: coordinator
            )
        case let .transfer(wallet, coordinator):
            TransferConfigurator.build(wallet: wallet, coordinator: coordinator)
        case let .chooseReceiver(address, coordinator):
            ChooseReceiverAssembly.build(receiverData: address, coordinator: coordinator)
        case let .facilityApprove(transaction, coordinator):
            FacilityApproveConfigurator.build(
                transaction: transaction,
                coordinator: coordinator
            )
        case let .showTokenInfo(wallet):
            TokenInfoAssembly.build(wallet: wallet)
        case let .adressScanner(value: value):
            WalletAddressScanerView(scannedCode: value)
        }
    }

    @ViewBuilder
    private func sheetContent(item: WalletSheetLink) -> some View {
        switch item {
        case let .transactionResult(model):
                TransactionResultAssembly.build(model: model)
        case let .addSeed(addSeedView):
                addSeedView()
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

    func presentedItem() -> Binding<WalletSheetLink?> {
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
            WalletContentLink.transaction(
                filterIndex: filterIndex,
                tokenIndex: tokenIndex,
                address: address,
                coordinator: coordinator
            )
        )
    }

    func showTokenInfo(wallet: WalletInfo) {
        state.path.append(
            WalletContentLink.showTokenInfo(wallet: wallet)
        )
    }
}
